//
//  CustomDialogView.swift
//  VRUIComponents
//
//  Custom themed confirmation dialogs using VRStateManagement types
//  Add this file to: Sources/VRUIComponents/Components/CustomDialogView.swift
//

import SwiftUI
import VRStateManagement

// MARK: - CustomDialog Convenience Extensions

extension CustomDialog {
    /// Create a destructive dialog (e.g., for delete confirmations)
    public static func destructive(
        title: String,
        message: String,
        icon: String = "xmark.circle.fill",
        confirmTitle: String = "Delete",
        onConfirm: @escaping @MainActor @Sendable () -> Void
    ) -> CustomDialog {
        CustomDialog(
            title: title,
            message: message,
            icon: icon,
            iconColor: "#FF9500",  // Orange - less aggressive than red
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
    
    /// Create a confirmation dialog (e.g., for important actions)
    public static func confirmation(
        title: String,
        message: String,
        icon: String = "checkmark.circle.fill",
        confirmTitle: String = "Confirm",
        onConfirm: @escaping @MainActor @Sendable () -> Void
    ) -> CustomDialog {
        CustomDialog(
            title: title,
            message: message,
            icon: icon,
            iconColor: "#007AFF",  // Blue
            primaryButton: DialogButton(
                title: confirmTitle,
                role: .default,
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

// MARK: - Custom Dialog View

public struct CustomDialogView: View {
    let dialog: CustomDialog
    let onDismiss: () -> Void
    @Environment(\.appTheme) private var theme
    
    public init(dialog: CustomDialog, onDismiss: @escaping () -> Void) {
        self.dialog = dialog
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            // Dialog content
            VStack(spacing: 0) {
                // Icon and Title
                VStack(spacing: theme.spacingMD) {
                    Image(systemName: dialog.icon)
                        .font(.system(size: 50))
                        .foregroundColor(colorFromHex(dialog.iconColor))
                    
                    Text(dialog.title)
                        .font(theme.fontTitle2)
                        .fontWeight(.bold)
                        .foregroundColor(theme.textPrimaryColor)
                    
                    Text(dialog.message)
                        .font(theme.fontBody)
                        .foregroundColor(theme.textSecondaryColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, theme.spacingMD)
                }
                .padding(.top, theme.spacingXL)
                .padding(.bottom, theme.spacingLG)
                
                // Buttons
                VStack(spacing: theme.spacingXS) {
                    // Primary button
                    Button(action: {
                        dialog.primaryButton.action?()
                        onDismiss()
                    }) {
                        Text(dialog.primaryButton.title)
                            .font(theme.fontHeadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, theme.spacingMD)
                            .background(buttonColor(for: dialog.primaryButton.role))
                            .cornerRadius(theme.cornerRadiusMD)
                    }
                    
                    // Secondary button (if exists)
                    if let secondaryButton = dialog.secondaryButton {
                        Button(action: {
                            secondaryButton.action?()
                            onDismiss()
                        }) {
                            Text(secondaryButton.title)
                                .font(theme.fontHeadline)
                                .foregroundColor(theme.textPrimaryColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, theme.spacingMD)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(theme.cornerRadiusMD)
                        }
                    }
                }
                .padding(.horizontal, theme.spacingLG)
                .padding(.bottom, theme.spacingLG)
            }
            .frame(maxWidth: 340)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadiusLG)
                    .fill(theme.surfaceColor)
                    .shadow(
                        color: theme.shadowColor,
                        radius: theme.shadowRadius,
                        x: theme.shadowX,
                        y: theme.shadowY
                    )
            )
        }
        .transition(.opacity.combined(with: .scale(scale: 0.9)))
    }
    
    private func buttonColor(for role: DialogButton.ButtonRole) -> Color {
        switch role {
        case .destructive:
            return Color.orange  // Less aggressive than red
        case .cancel:
            return Color.gray
        case .default:
            return theme.primaryColor
        }
    }
    
    private func colorFromHex(_ hex: String) -> Color {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        return Color(red: r, green: g, blue: b)
    }
}

// MARK: - Dialog Modifier

public struct CustomDialogModifier: ViewModifier {
    @Binding var dialog: CustomDialog?
    
    public init(dialog: Binding<CustomDialog?>) {
        self._dialog = dialog
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            if let dialog = dialog {
                CustomDialogView(dialog: dialog) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.dialog = nil
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
                .zIndex(999)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: dialog != nil)
    }
}

// MARK: - View Extension

extension View {
    /// Display a custom dialog when the binding is not nil
    public func customDialog(_ dialog: Binding<CustomDialog?>) -> some View {
        modifier(CustomDialogModifier(dialog: dialog))
    }
}
