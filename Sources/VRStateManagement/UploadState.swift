import Foundation

/// State pattern for file upload operations
@frozen
public enum UploadState: Equatable, Sendable {
    case none
    case uploading(activeCount: Int, totalCount: Int)
    case error(message: String, canRetry: Bool)
    case success(message: String)
    
    public var isUploading: Bool {
        if case .uploading = self { return true }
        return false
    }
    
    public var showError: Bool {
        if case .error = self { return true }
        return false
    }
    
    public var showSuccess: Bool {
        if case .success = self { return true }
        return false
    }
    
    public var errorMessage: String? {
        if case .error(let message, _) = self { return message }
        return nil
    }
    
    public var canRetry: Bool {
        if case .error(_, let canRetry) = self { return canRetry }
        return false
    }
    
    public var successMessage: String? {
        if case .success(let message) = self { return message }
        return nil
    }
    
    public var uploadProgress: (active: Int, total: Int)? {
        if case .uploading(let active, let total) = self {
            return (active, total)
        }
        return nil
    }
}
