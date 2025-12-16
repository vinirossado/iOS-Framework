import Foundation

/// Generic state for data loading operations
@frozen
public enum LoadState<T: Sendable>: Sendable {
    case idle
    case loading
    case loaded(T)
    case error(Error)
    
    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    public var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }
    
    public var data: T? {
        if case .loaded(let data) = self { return data }
        return nil
    }
    
    public var error: Error? {
        if case .error(let error) = self { return error }
        return nil
    }
}

extension LoadState: Equatable where T: Equatable {
    public static func == (lhs: LoadState<T>, rhs: LoadState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.loaded(let lhsData), .loaded(let rhsData)):
            return lhsData == rhsData
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
