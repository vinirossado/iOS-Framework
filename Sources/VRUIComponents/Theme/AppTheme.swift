import SwiftUI

/// Protocol that defines semantic colors for the app
/// Each app implements this protocol to provide custom colors
/// Other styling (fonts, spacing, etc.) use SwiftUI defaults
public protocol AppTheme: Sendable {
    // MARK: - Semantic Colors (Required)
    var errorColor: Color { get }
    var successColor: Color { get }
    var warningColor: Color { get }
    var infoColor: Color { get }
    
    // MARK: - Basic Colors (Required for Card component)
    var surfaceColor: Color { get }
    
    // MARK: - Text Colors (Required for CustomDialog)
    var textPrimaryColor: Color { get }
    var textSecondaryColor: Color { get }
    
    // MARK: - Optional Brand Colors (can be used by apps if needed)
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var accentColor: Color { get }
    var backgroundColor: Color { get }
    var textTertiaryColor: Color { get }
    
    // MARK: - Legacy Properties (deprecated, will be removed)
    // These are kept for backward compatibility but should not be used
    // All components now use SwiftUI defaults (.callout, .caption, etc.)
    @available(*, deprecated, message: "Use SwiftUI .largeTitle instead")
    var fontLargeTitle: Font { get }
    @available(*, deprecated, message: "Use SwiftUI .title instead")
    var fontTitle: Font { get }
    @available(*, deprecated, message: "Use SwiftUI .title2 instead")
    var fontTitle2: Font { get }
    @available(*, deprecated, message: "Use SwiftUI .title3 instead")
    var fontTitle3: Font { get }
    @available(*, deprecated, message: "Use SwiftUI .headline instead")
    var fontHeadline: Font { get }
    @available(*, deprecated, message: "Use SwiftUI .body instead")
    var fontBody: Font { get }
    @available(*, deprecated, message: "Use SwiftUI .callout instead")
    var fontCallout: Font { get }
    @available(*, deprecated, message: "Use SwiftUI .subheadline instead")
    var fontSubheadline: Font { get }
    @available(*, deprecated, message: "Use SwiftUI .footnote instead")
    var fontFootnote: Font { get }
    @available(*, deprecated, message: "Use SwiftUI .caption instead")
    var fontCaption: Font { get }
    @available(*, deprecated, message: "Use SwiftUI .caption2 instead")
    var fontCaption2: Font { get }
    
    @available(*, deprecated, message: "Use hardcoded values in components")
    var spacingXS: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var spacingSM: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var spacingMD: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var spacingLG: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var spacingXL: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var spacingXXL: CGFloat { get }
    
    @available(*, deprecated, message: "Use hardcoded values in components")
    var cornerRadiusXS: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var cornerRadiusSM: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var cornerRadiusMD: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var cornerRadiusLG: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var cornerRadiusXL: CGFloat { get }
    
    @available(*, deprecated, message: "Use hardcoded values in components")
    var shadowColor: Color { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var shadowRadius: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var shadowX: CGFloat { get }
    @available(*, deprecated, message: "Use hardcoded values in components")
    var shadowY: CGFloat { get }
}
