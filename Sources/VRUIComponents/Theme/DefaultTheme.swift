import SwiftUI

/// Default theme implementation
/// Apps should create their own custom theme by implementing AppTheme
public struct DefaultTheme: AppTheme {
    public init() {}

    // MARK: - Semantic Colors (Required)
    public var errorColor: Color = .red
    public var successColor: Color = .green
    public var warningColor: Color = .orange
    public var infoColor: Color = .blue

    // MARK: - Basic Colors
    public var surfaceColor: Color = Color(.secondarySystemBackground)
    public var textPrimaryColor: Color = Color(.label)
    public var textSecondaryColor: Color = Color(.secondaryLabel)
    
    // MARK: - Optional Brand Colors
    public var primaryColor: Color = .blue
    public var secondaryColor: Color = .gray
    public var accentColor: Color = .orange
    public var backgroundColor: Color = Color(.systemBackground)
    public var textTertiaryColor: Color = Color(.tertiaryLabel)

    // MARK: - Deprecated Properties (kept for backward compatibility)
    public var fontLargeTitle: Font = .largeTitle
    public var fontTitle: Font = .title
    public var fontTitle2: Font = .title2
    public var fontTitle3: Font = .title3
    public var fontHeadline: Font = .headline
    public var fontBody: Font = .body
    public var fontCallout: Font = .callout
    public var fontSubheadline: Font = .subheadline
    public var fontFootnote: Font = .footnote
    public var fontCaption: Font = .caption
    public var fontCaption2: Font = .caption2

    public var spacingXS: CGFloat = 4
    public var spacingSM: CGFloat = 8
    public var spacingMD: CGFloat = 16
    public var spacingLG: CGFloat = 24
    public var spacingXL: CGFloat = 32
    public var spacingXXL: CGFloat = 48

    public var cornerRadiusXS: CGFloat = 4
    public var cornerRadiusSM: CGFloat = 8
    public var cornerRadiusMD: CGFloat = 12
    public var cornerRadiusLG: CGFloat = 16
    public var cornerRadiusXL: CGFloat = 24

    public var shadowColor: Color = Color.black.opacity(0.1)
    public var shadowRadius: CGFloat = 4
    public var shadowX: CGFloat = 0
    public var shadowY: CGFloat = 2
}
