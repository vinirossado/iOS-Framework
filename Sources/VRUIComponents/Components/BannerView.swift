import SwiftUI
import VRStateManagement

/// Banner view for displaying errors, success messages, etc.
public struct BannerView: View {
    @Environment(\.appTheme) private var theme
    
    let type: BannerType
    let message: String
    let actionTitle: String?
    let onDismiss: () -> Void
    let onAction: (() -> Void)?
    
    public init(
        type: BannerType,
        message: String,
        actionTitle: String? = nil,
        onDismiss: @escaping () -> Void,
        onAction: (() -> Void)? = nil
    ) {
        self.type = type
        self.message = message
        self.actionTitle = actionTitle
        self.onDismiss = onDismiss
        self.onAction = onAction
    }
    
    public var body: some View {
        HStack(spacing: theme.spacingSM) {
            Image(systemName: iconName)
                .foregroundColor(textColor)
            
            Text(message)
                .font(theme.fontBody)
                .foregroundColor(textColor)
            
            Spacer()
            
            if let actionTitle, let onAction {
                Button(actionTitle, action: onAction)
                    .font(theme.fontCallout.bold())
                    .foregroundColor(textColor)
            }
            
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(textColor)
            }
        }
        .padding(theme.spacingMD)
        .background(backgroundColor)
        .cornerRadius(theme.cornerRadiusMD)
        .shadow(color: theme.shadowColor, radius: theme.shadowRadius, x: theme.shadowX, y: theme.shadowY)
    }
    
    private var backgroundColor: Color {
        switch type {
        case .error: return theme.errorColor
        case .success: return theme.successColor
        case .warning: return theme.warningColor
        case .info: return theme.infoColor
        }
    }
    
    private var textColor: Color {
        .white
    }
    
    private var iconName: String {
        switch type {
        case .error: return "exclamationmark.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

public enum BannerType {
    case error
    case success
    case warning
    case info
}

// MARK: - View Extension for Banners

extension View {
    /// Display error or success banners using FeedbackState
    public func banner(feedbackState: Binding<FeedbackState>) -> some View {
        self.modifier(BannerModifier(feedbackState: feedbackState))
    }
}

struct BannerModifier: ViewModifier {
    @Binding var feedbackState: FeedbackState
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if let errorBanner = feedbackState.errorBanner {
                BannerView(
                    type: .error,
                    message: errorBanner.message,
                    actionTitle: errorBanner.actionTitle,
                    onDismiss: { feedbackState = .none },
                    onAction: errorBanner.action
                )
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            if let successBanner = feedbackState.successBanner {
                BannerView(
                    type: .success,
                    message: successBanner.message,
                    onDismiss: { feedbackState = .none }
                )
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
                .task {
                    try? await Task.sleep(nanoseconds: UInt64(successBanner.duration * 1_000_000_000))
                    feedbackState = .none
                }
            }
        }
        .animation(.spring(), value: feedbackState)
    }
}
