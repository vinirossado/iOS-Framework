import Alamofire
import Combine
import Foundation

// MARK: - API Error

@frozen
public enum APIError: LocalizedError, Sendable {
    case invalidURL
    case invalidResponse
    case encodingFailed(Error)
    case decodingFailed(Error)
    case networkError(Error)
    case badRequest(String)
    case unauthorized(message: String?)
    case forbidden(message: String?)
    case notFound(message: String?)
    case conflict(message: String?)
    case notModified
    case preconditionFailed(currentETag: String)
    case validationError([String: [String]])
    case serverError(message: String?)
    case unknownError(Int)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .encodingFailed(let error):
            return "Encoding failed: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .badRequest(let message):
            return message
        case .unauthorized(let message):
            return message ?? "You are not authorized to perform this action"
        case .forbidden(let message):
            return message ?? "Access forbidden"
        case .notFound(let message):
            return message ?? "Resource not found"
        case .conflict(let message):
            return message ?? "A conflict occurred"
        case .notModified:
            return "Not modified - use cached data"
        case .preconditionFailed(let currentETag):
            return "Precondition failed - conflict detected (current ETag: \(currentETag))"
        case .validationError(let errors):
            let errorMessages = errors.values.flatMap { $0 }.joined(separator: ", ")
            return "Validation error: \(errorMessages)"
        case .serverError(let message):
            return message ?? "Server error occurred"
        case .unknownError(let code):
            return "Unknown error: \(code)"
        }
    }
}

// MARK: - API Service Protocol

public protocol APIServiceProtocol: Sendable {
    func request<T: Codable>(
        _ endpoint: APIEndpoint, 
        responseType: T.Type, 
        ifNoneMatch etag: String?
    ) async throws(APIError) -> ETagResponse<T>
    
    func requestData(
        _ endpoint: APIEndpoint, 
        ifNoneMatch etag: String?
    ) async throws(APIError) -> (data: Data, etag: String?, notModified: Bool)
    
    func requestWithoutResponse(_ endpoint: APIEndpoint) async throws(APIError)
}

// MARK: - Protocol Extension for Default Parameters

public extension APIServiceProtocol {
    func request<T: Codable>(
        _ endpoint: APIEndpoint, 
        responseType: T.Type
    ) async throws(APIError) -> ETagResponse<T> {
        return try await request(endpoint, responseType: responseType, ifNoneMatch: nil)
    }

    func requestData(_ endpoint: APIEndpoint) async throws(APIError) -> (
        data: Data, etag: String?, notModified: Bool
    ) {
        return try await requestData(endpoint, ifNoneMatch: nil)
    }
}

// MARK: - Trust All Certificates Delegate (Development Only)

class TrustAllCertificatesDelegate: NSObject, URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.performDefaultHandling, nil)
            return
        }

        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }
}

// MARK: - API Service Implementation

public final class APIService: APIServiceProtocol {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let afSession: Session
    private let authTokenProvider: (() -> String?)?
    private let onUnauthorized: (() async -> Void)?

    private let retryLock = NSLock()
    private var _isRetryingAfterRefresh = false

    private var isRetryingAfterRefresh: Bool {
        get {
            retryLock.lock()
            defer { retryLock.unlock() }
            return _isRetryingAfterRefresh
        }
        set {
            retryLock.lock()
            defer { retryLock.unlock() }
            _isRetryingAfterRefresh = newValue
        }
    }

    public init(
        baseURL: String,
        configuration: APIConfiguration? = nil,
        authTokenProvider: (() -> String?)? = nil,
        onUnauthorized: (() async -> Void)? = nil,
        session: URLSession = .shared
    ) {
        guard let url = URL(string: baseURL) else {
            fatalError("Invalid base URL: \(baseURL)")
        }
        self.baseURL = url
        self.authTokenProvider = authTokenProvider
        self.onUnauthorized = onUnauthorized

        let isDevelopment = configuration?.isDevelopmentURL(baseURL) ?? APIConfiguration.isDevelopmentURL(baseURL)
        
        if isDevelopment {
            let config = URLSessionConfiguration.default
            self.session = URLSession(
                configuration: config,
                delegate: TrustAllCertificatesDelegate(),
                delegateQueue: nil
            )
        } else {
            self.session = session
        }

        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601

        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601

        var evaluators: [String: any ServerTrustEvaluating] = [:]

        if isDevelopment, let config = configuration {
            for host in config.developmentHosts {
                evaluators[host] = DisabledTrustEvaluator()
            }
        }

        let trustManager = ServerTrustManager(
            allHostsMustBeEvaluated: false, 
            evaluators: evaluators
        )

        let afConfig = URLSessionConfiguration.default
        afConfig.httpAdditionalHeaders = [
            "Accept": "application/json", 
            "Content-Type": "application/json",
        ]
        afConfig.timeoutIntervalForRequest = 30
        afConfig.timeoutIntervalForResource = 60
        afConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        afConfig.urlCache = nil

        self.afSession = Session(configuration: afConfig, serverTrustManager: trustManager)
    }

    public func request<T: Codable>(
        _ endpoint: APIEndpoint, 
        responseType: T.Type, 
        ifNoneMatch etag: String? = nil
    ) async throws(APIError) -> ETagResponse<T> {
        do {
            let (data, responseETag, notModified) = try await requestData(
                endpoint, ifNoneMatch: etag)

            if notModified {
                return ETagResponse(data: nil, etag: responseETag ?? etag ?? "", notModified: true)
            }

            do {
                do {
                    let apiResponse = try decoder.decode(ApiResponse<T>.self, from: data)
                    guard let unwrappedData = apiResponse.data else {
                        throw APIError.invalidResponse
                    }
                    return ETagResponse(
                        data: unwrappedData, etag: responseETag ?? "", notModified: false)
                } catch {
                    let decoded = try decoder.decode(responseType, from: data)
                    return ETagResponse(
                        data: decoded, etag: responseETag ?? "", notModified: false)
                }
            } catch {
                throw APIError.decodingFailed(error)
            }
        } catch let error as APIError {
            if case .unauthorized = error {
                if !isRetryingAfterRefresh, let onUnauthorized = onUnauthorized {
                    isRetryingAfterRefresh = true
                    defer { isRetryingAfterRefresh = false }

                    await onUnauthorized()
                    return try await request(
                        endpoint, responseType: responseType, ifNoneMatch: etag)
                }
            }
            throw error
        }
    }

    public func requestData(
        _ endpoint: APIEndpoint, 
        ifNoneMatch etag: String? = nil
    ) async throws(APIError) -> (data: Data, etag: String?, notModified: Bool) {
        var modifiedEndpoint = endpoint

        if let etag = etag {
            modifiedEndpoint.headers["If-None-Match"] = etag
        }

        let request = try buildRequest(for: modifiedEndpoint)

        let dataTask = afSession.request(request).serializingData()
        let response = await dataTask.response

        guard let httpResponse = response.response else {
            throw APIError.invalidResponse
        }

        let responseETag = httpResponse.value(forHTTPHeaderField: "ETag")

        if httpResponse.statusCode == 304 {
            return (data: Data(), etag: responseETag ?? etag, notModified: true)
        }

        do {
            let data: Data
            do {
                data = try await dataTask.value
            } catch {
                if httpResponse.statusCode == 401 {
                    try validateResponse(httpResponse, data: Data())
                }
                throw error
            }

            try validateResponse(httpResponse, data: data)
            return (data: data, etag: responseETag, notModified: false)
        } catch {
            if let afError = error as? AFError, let underlying = afError.underlyingError {
                if httpResponse.statusCode == 401 {
                    try? validateResponse(httpResponse, data: Data())
                }
                throw APIError.networkError(underlying)
            }
            if error is APIError {
                throw error
            }
            throw APIError.networkError(error)
        }
    }

    public func requestWithoutResponse(_ endpoint: APIEndpoint) async throws(APIError) {
        let request = try buildRequest(for: endpoint)

        let dataTask = afSession.request(request).serializingResponse(using: .data)
        let response = await dataTask.response
        
        guard let httpResponse = response.response else {
            throw APIError.invalidResponse
        }

        do {
            try validateResponse(httpResponse, data: Data())
        } catch {
            if error is APIError { throw error }
            throw APIError.networkError(error)
        }
    }

    // MARK: - Private Methods

    private func buildRequest(for endpoint: APIEndpoint) throws(APIError) -> URLRequest {
        let url = baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)

        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = authTokenProvider?() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        if !endpoint.queryParameters.isEmpty {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = endpoint.queryParameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            if let finalURL = urlComponents?.url {
                request.url = finalURL
            }
        }

        if let body = endpoint.body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                throw APIError.encodingFailed(error)
            }
        }

        return request
    }

    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws(APIError) {
        switch response.statusCode {
        case 200...299:
            return
        case 400:
            if let apiError = try? decoder.decode(ApiErrorResponse.self, from: data) {
                throw APIError.badRequest(apiError.message)
            }
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw APIError.badRequest(errorResponse.message)
            }
            throw APIError.badRequest("Bad request")
        case 401:
            if let apiError = try? decoder.decode(ApiErrorResponse.self, from: data) {
                throw APIError.unauthorized(message: apiError.message)
            }
            throw APIError.unauthorized(message: nil)
        case 403:
            if let apiError = try? decoder.decode(ApiErrorResponse.self, from: data) {
                throw APIError.forbidden(message: apiError.message)
            }
            throw APIError.forbidden(message: nil)
        case 404:
            if let apiError = try? decoder.decode(ApiErrorResponse.self, from: data) {
                throw APIError.notFound(message: apiError.message)
            }
            throw APIError.notFound(message: nil)
        case 409:
            if let apiError = try? decoder.decode(ApiErrorResponse.self, from: data) {
                throw APIError.conflict(message: apiError.message)
            }
            throw APIError.conflict(message: nil)
        case 412:
            let currentETag = response.value(forHTTPHeaderField: "ETag") ?? ""
            throw APIError.preconditionFailed(currentETag: currentETag)
        case 422:
            if let errorResponse = try? decoder.decode(ValidationErrorResponse.self, from: data) {
                throw APIError.validationError(errorResponse.errors)
            }
            throw APIError.validationError([:])
        case 500...599:
            if let apiError = try? decoder.decode(ApiErrorResponse.self, from: data) {
                throw APIError.serverError(message: apiError.message)
            }
            throw APIError.serverError(message: nil)
        default:
            throw APIError.unknownError(response.statusCode)
        }
    }
}
