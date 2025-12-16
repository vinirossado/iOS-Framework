import SwiftUI

/// Generic card component with customizable styling
public struct Card<Content: View>: View {
    @Environment(\.appTheme) private var theme
    
    private let content: Content
    private let padding: CGFloat?
    private let cornerRadius: CGFloat?
    private let shadowEnabled: Bool
    
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
            .padding(padding ?? theme.spacingMD)
            .background(theme.surfaceColor)
            .cornerRadius(cornerRadius ?? theme.cornerRadiusMD)
            .shadow(
                color: shadowEnabled ? theme.shadowColor : .clear,
                radius: shadowEnabled ? theme.shadowRadius : 0,
                x: shadowEnabled ? theme.shadowX : 0,
                y: shadowEnabled ? theme.shadowY : 0
            )
    }
}
