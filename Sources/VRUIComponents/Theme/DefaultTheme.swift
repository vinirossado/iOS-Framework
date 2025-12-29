import SwiftUI

/// Default theme implementation
/// Apps should create their own custom theme by implementing AppTheme
public struct DefaultTheme: AppTheme {
    public init() {}

    // MARK: - Semantic Colors
    public var errorColor: Color = .red
    public var successColor: Color = .green
    public var warningColor: Color = .orange
    public var infoColor: Color = .blue

    // MARK: - Surface & Text Colors
    public var surfaceColor: Color = Color(.secondarySystemBackground)
    public var textPrimaryColor: Color = Color(.label)
    public var textSecondaryColor: Color = Color(.secondaryLabel)
}
