import Foundation

public struct APIConfiguration {
    public let defaultBaseURL: String
    public let developmentHosts: [String]
    
    public init(
        defaultBaseURL: String,
        developmentHosts: [String] = ["localhost", "127.0.0.1"]
    ) {
        self.defaultBaseURL = defaultBaseURL
        self.developmentHosts = developmentHosts
    }
    
    public var baseURL: String {
        return defaultBaseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
    
    public static func isDevelopmentURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString), let host = url.host else {
            return false
        }

        if url.scheme == "http" { return true }
        if host == "localhost" || host == "127.0.0.1" { return true }
        if host.hasSuffix(".local") { return true }

        if host.hasPrefix("10.") { return true }
        if host.hasPrefix("192.168.") { return true }
        if host.hasPrefix("172.16.") || host.hasPrefix("172.17.") || host.hasPrefix("172.18.")
            || host.hasPrefix("172.19.") || host.hasPrefix("172.20.") || host.hasPrefix("172.21.")
            || host.hasPrefix("172.22.") || host.hasPrefix("172.23.") || host.hasPrefix("172.24.")
            || host.hasPrefix("172.25.") || host.hasPrefix("172.26.") || host.hasPrefix("172.27.")
            || host.hasPrefix("172.28.") || host.hasPrefix("172.29.") || host.hasPrefix("172.30.")
            || host.hasPrefix("172.31.")
        {
            return true
        }

        return false
    }
    
    public func isDevelopmentURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString), let host = url.host else {
            return false
        }
        
        if Self.isDevelopmentURL(urlString) { return true }
        
        return developmentHosts.contains(host)
    }
    
    public static func join(base: String, path: String) -> String {
        var normalizedBase = base
        if !normalizedBase.hasSuffix("/") { normalizedBase += "/" }
        if path.hasPrefix("/") { return normalizedBase + String(path.dropFirst()) }
        return normalizedBase + path
    }
}
