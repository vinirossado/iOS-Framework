import SwiftUI

/// Environment key for app theme
@MainActor
struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: any AppTheme = DefaultTheme()
}

extension EnvironmentValues {
    /// Access the app theme from the environment
    public var appTheme: any AppTheme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

/// View extension for easy theme injection
extension View {
    /// Set the theme for this view and all its children
    /// - Parameter theme: The theme to use
    /// - Returns: View with theme injected into environment
    public func theme(_ theme: any AppTheme) -> some View {
        environment(\.appTheme, theme)
    }
}
