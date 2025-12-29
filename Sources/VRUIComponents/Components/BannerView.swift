import SwiftUI
import VRStateManagement

/// Banner view for displaying errors, success messages, etc.
/// Uses only semantic colors from AppTheme, all other styling is built-in
public struct BannerView: View {
    @Environment(\.appTheme) private var theme

    let type: BannerType
    let title: String
    let message: String
    let onDismiss: () -> Void

    public init(
        type: BannerType,
        title: String,
        message: String,
        onDismiss: @escaping () -> Void
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: iconName)
                .foregroundColor(textColor)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.callout.bold())
                    .foregroundColor(textColor)

                Text(message)
                    .font(.caption)
                    .foregroundColor(textColor)
            }

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .foregroundColor(textColor)
            }
        }
        .padding(16)
        .background(backgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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
                    title: errorBanner.title,
                    message: errorBanner.message,
                    onDismiss: { feedbackState = .none }
                )
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            if let successBanner = feedbackState.successBanner {
                BannerView(
                    type: .success,
                    title: successBanner.title,
                    message: successBanner.message,
                    onDismiss: { feedbackState = .none }
                )
                .padding()
                .transition(.move(edge: .top).combined(with: .opacity))
                .task {
                    try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
                    feedbackState = .none
                }
            }
        }
        .animation(.spring(), value: feedbackState)
    }
}
