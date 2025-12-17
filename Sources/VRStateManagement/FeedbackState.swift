import Foundation
import SwiftUI

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
public struct ErrorBanner: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let title: String
    public let message: String
    public let recoverySuggestion: String?
    public let context: String

    public init(
        title: String, message: String, recoverySuggestion: String? = nil, context: String = ""
    ) {
        self.title = title
        self.message = message
        self.recoverySuggestion = recoverySuggestion
        self.context = context
    }

    public static func == (lhs: ErrorBanner, rhs: ErrorBanner) -> Bool {
        lhs.id == rhs.id
    }
}

/// Success banner model
public struct SuccessBanner: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let title: String
    public let message: String

    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }

    public static func == (lhs: SuccessBanner, rhs: SuccessBanner) -> Bool {
        lhs.id == rhs.id
    }
}

/// Custom dialog model
public struct CustomDialog: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public let title: String
    public let message: String
    public let icon: String
    public let iconColor: String  // Stored as hex string for Sendable compatibility
    public let primaryButton: DialogButton
    public let secondaryButton: DialogButton?

    public init(
        title: String,
        message: String,
        icon: String,
        iconColor: String,
        primaryButton: DialogButton,
        secondaryButton: DialogButton? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.iconColor = iconColor
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }

    public static func == (lhs: CustomDialog, rhs: CustomDialog) -> Bool {
        lhs.id == rhs.id
    }

    // Convenience initializers for common scenarios
    static func destructive(
        title: String,
        message: String,
        icon: String = "xmark.circle.fill",
        iconColor: string = "#c0392b",
        confirmTitle: String = "Delete",
        onConfirm: @escaping @MainActor @Sendable () -> Void
    ) -> CustomDialog {
        CustomDialog(
            title: title,
            message: message,
            icon: icon,
            iconColor: iconColor,
            primaryButton: DialogButton(
                title: confirmTitle,
                role: .destructive,
                action: onConfirm
            ),
            secondaryButton: DialogButton(
                title: "Cancel",
                role: .cancel,
                action: {}
            )
        )
    }
}

/// Dialog button model
public struct DialogButton: Equatable, Sendable {
    public let title: String
    public let role: ButtonRole
    public let action: (@MainActor () -> Void)?

    public init(
        title: String,
        role: ButtonRole = .default,
        action: (@MainActor () -> Void)? = nil
    ) {
        self.title = title
        self.role = role
        self.action = action
    }

    public static func == (lhs: DialogButton, rhs: DialogButton) -> Bool {
        lhs.title == rhs.title && lhs.role == rhs.role
    }

    public enum ButtonRole: Equatable, Sendable {
        case `default`
        case cancel
        case destructive
    }
}
