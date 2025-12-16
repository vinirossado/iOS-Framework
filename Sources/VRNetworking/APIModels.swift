import Foundation

// MARK: - HTTP Method

public enum HTTPMethod: String, Sendable {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

// MARK: - API Endpoint

public struct APIEndpoint: Sendable {
    public let path: String
    public let method: HTTPMethod
    public let queryParameters: [String: Any]
    public let body: (any Codable)?
    public var headers: [String: String]

    public init(
        path: String,
        method: HTTPMethod,
        queryParameters: [String: Any] = [:],
        body: (any Codable)? = nil,
        headers: [String: String] = [:]
    ) {
        self.path = path
        self.method = method
        self.queryParameters = queryParameters
        self.body = body
        self.headers = headers
    }
}

// MARK: - ETag Response

public struct ETagResponse<T: Codable & Sendable>: Sendable {
    public let data: T?
    public let etag: String
    public let notModified: Bool
    
    public init(data: T?, etag: String, notModified: Bool) {
        self.data = data
        self.etag = etag
        self.notModified = notModified
    }
}

// MARK: - API Response Wrapper

public struct ApiResponse<T: Codable & Sendable>: Codable, Sendable {
    public let data: T?
    public let message: String?
    public let success: Bool
    
    public init(data: T?, message: String?, success: Bool) {
        self.data = data
        self.message = message
        self.success = success
    }
}

// MARK: - API Error Response

public struct ApiErrorResponse: Codable, Sendable {
    public let success: Bool
    public let data: String?
    public let message: String
    
    public init(success: Bool, data: String?, message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - Error Response (Legacy)

public struct ErrorResponse: Codable, Sendable {
    public let message: String
    public let details: String?
    
    public init(message: String, details: String?) {
        self.message = message
        self.details = details
    }
}

// MARK: - Validation Error Response

public struct ValidationErrorResponse: Codable, Sendable {
    public let message: String
    public let errors: [String: [String]]
    
    public init(message: String, errors: [String: [String]]) {
        self.message = message
        self.errors = errors
    }
}
