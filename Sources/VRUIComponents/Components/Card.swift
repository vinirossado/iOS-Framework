import SwiftUI

/// Reusable card component with consistent styling
/// Uses only surfaceColor from AppTheme, all other styling is built-in
public struct Card<Content: View>: View {
    @Environment(\.appTheme) private var theme
    
    let content: Content
    let padding: CGFloat?
    let cornerRadius: CGFloat?
    let shadowEnabled: Bool
    
    public init(
        padding: CGFloat? = nil,
        cornerRadius: CGFloat? = nil,
        shadowEnabled: Bool = true,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowEnabled = shadowEnabled
    }
    
    public var body: some View {
        content
            .padding(padding ?? 16)
            .background(theme.surfaceColor)
            .cornerRadius(cornerRadius ?? 12)
            .shadow(
                color: shadowEnabled ? Color.black.opacity(0.1) : .clear,
                radius: shadowEnabled ? 4 : 0,
                x: 0,
                y: shadowEnabled ? 2 : 0
            )
    }
}
