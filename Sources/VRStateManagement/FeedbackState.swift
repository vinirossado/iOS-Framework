import Foundation

/// Reusable state pattern for user feedback (errors, success messages, dialogs)
@frozen
public enum FeedbackState: Equatable, Sendable {
    case none
    case error(ErrorBanner)
    case success(SuccessBanner)
    case customDialog(CustomDialog)
    
    public var showError: Bool {
        if case .error = self { return true }
        return false
    }
    
    public var showSuccess: Bool {
        if case .success = self { return true }
        return false
    }
    
    public var showDialog: Bool {
        if case .customDialog = self { return true }
        return false
    }
    
    public var errorBanner: ErrorBanner? {
        if case .error(let banner) = self { return banner }
        return nil
    }
    
    public var successBanner: SuccessBanner? {
        if case .success(let banner) = self { return banner }
        return nil
    }
    
    public var customDialog: CustomDialog? {
        if case .customDialog(let dialog) = self { return dialog }
        return nil
    }
}

/// Error banner model
public struct ErrorBanner: Equatable, Sendable {
    public let message: String
    public let actionTitle: String?
    public let action: (() -> Void)?
    
    public init(message: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public static func == (lhs: ErrorBanner, rhs: ErrorBanner) -> Bool {
        lhs.message == rhs.message && lhs.actionTitle == rhs.actionTitle
    }
}

/// Success banner model
public struct SuccessBanner: Equatable, Sendable {
    public let message: String
    public let duration: TimeInterval
    
    public init(message: String, duration: TimeInterval = 3.0) {
        self.message = message
        self.duration = duration
    }
}

/// Custom dialog model
public struct CustomDialog: Equatable, Sendable {
    public let title: String
    public let message: String
    public let buttons: [DialogButton]
    
    public init(title: String, message: String, buttons: [DialogButton]) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}

/// Dialog button model
public struct DialogButton: Equatable, Sendable {
    public let title: String
    public let role: ButtonRole
    public let action: (() -> Void)?
    
    public init(title: String, role: ButtonRole = .normal, action: (() -> Void)? = nil) {
        self.title = title
        self.role = role
        self.action = action
    }
    
    public static func == (lhs: DialogButton, rhs: DialogButton) -> Bool {
        lhs.title == rhs.title && lhs.role == rhs.role
    }
    
    public enum ButtonRole: Sendable {
        case normal
        case cancel
        case destructive
    }
}
