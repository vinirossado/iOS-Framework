import SwiftUI
import VRStateManagement

/// Custom dialog view for displaying modal dialogs
/// Uses only textPrimaryColor and textSecondaryColor from AppTheme, all other styling is built-in
public struct CustomDialogView: View {
    @Environment(\.appTheme) private var theme

    let dialog: CustomDialog
    let onDismiss: () -> Void

    public init(dialog: CustomDialog, onDismiss: @escaping () -> Void) {
        self.dialog = dialog
        self.onDismiss = onDismiss
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack(spacing: 16) {
                // Icon
                Image(systemName: dialog.icon)
                    .font(.system(size: 50))
                    .foregroundColor(Color(hex: dialog.iconColor))

                // Title and Message
                VStack(spacing: 16) {
                    Text(dialog.title)
                        .font(.title2)
                        .foregroundColor(theme.textPrimaryColor)

                    Text(dialog.message)
                        .font(.body)
                        .foregroundColor(theme.textSecondaryColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                }
                .padding(.top, 32)

                // Buttons
                HStack(spacing: 12) {
                    if let secondaryButton = dialog.secondaryButton {
                        DialogButtonView(button: secondaryButton, onDismiss: onDismiss)
                    }

                    DialogButtonView(button: dialog.primaryButton, onDismiss: onDismiss, isPrimary: true)
                }
                .padding(.horizontal, 16)
            }
            .padding(24)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(32)
        }
    }
}

struct DialogButtonView: View {
    let button: DialogButton
    let onDismiss: () -> Void
    var isPrimary: Bool = false

    var body: some View {
        Button(action: {
            button.action?()
            onDismiss()
        }) {
            Text(button.title)
                .font(.headline)
                .foregroundColor(buttonTextColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(buttonBackgroundColor)
                .cornerRadius(12)
        }
    }

    private var buttonTextColor: Color {
        switch button.role {
        case .destructive, .default: return .white
        case .cancel: return .primary
        }
    }

    private var buttonBackgroundColor: Color {
        switch button.role {
        case .destructive: return .red
        case .default: return .blue
        case .cancel: return Color(.systemGray5)
        }
    }
}
