import SwiftUI

/// Protocol that defines all theme properties for the app
/// Each app implements this protocol to provide custom styling
public protocol AppTheme {
    // MARK: - Colors
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var accentColor: Color { get }
    var backgroundColor: Color { get }
    var surfaceColor: Color { get }
    var errorColor: Color { get }
    var successColor: Color { get }
    var warningColor: Color { get }
    var infoColor: Color { get }
    
    // Text Colors
    var textPrimaryColor: Color { get }
    var textSecondaryColor: Color { get }
    var textTertiaryColor: Color { get }
    
    // MARK: - Typography
    var fontLargeTitle: Font { get }
    var fontTitle: Font { get }
    var fontTitle2: Font { get }
    var fontTitle3: Font { get }
    var fontHeadline: Font { get }
    var fontBody: Font { get }
    var fontCallout: Font { get }
    var fontSubheadline: Font { get }
    var fontFootnote: Font { get }
    var fontCaption: Font { get }
    var fontCaption2: Font { get }
    
    // MARK: - Spacing
    var spacingXS: CGFloat { get }   // 4
    var spacingSM: CGFloat { get }   // 8
    var spacingMD: CGFloat { get }   // 16
    var spacingLG: CGFloat { get }   // 24
    var spacingXL: CGFloat { get }   // 32
    var spacingXXL: CGFloat { get }  // 48
    
    // MARK: - Border Radius
    var cornerRadiusXS: CGFloat { get }  // 4
    var cornerRadiusSM: CGFloat { get }  // 8
    var cornerRadiusMD: CGFloat { get }  // 12
    var cornerRadiusLG: CGFloat { get }  // 16
    var cornerRadiusXL: CGFloat { get }  // 24
    
    // MARK: - Shadows
    var shadowColor: Color { get }
    var shadowRadius: CGFloat { get }
    var shadowX: CGFloat { get }
    var shadowY: CGFloat { get }
}
