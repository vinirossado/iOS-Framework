import SwiftUI

/// Protocol that defines semantic colors for the app
/// Each app implements this protocol to provide custom colors
/// Other styling (fonts, spacing, etc.) use SwiftUI defaults
public protocol AppTheme: Sendable {
    // MARK: - Semantic Colors
    var errorColor: Color { get }
    var successColor: Color { get }
    var warningColor: Color { get }
    var infoColor: Color { get }

    // MARK: - Basic Colors
    var surfaceColor: Color { get }

    // MARK: - Text Colors
    var textPrimaryColor: Color { get }
    var textSecondaryColor: Color { get }
}
