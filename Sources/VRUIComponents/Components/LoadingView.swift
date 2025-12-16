import SwiftUI

/// Customizable loading view
public struct LoadingView: View {
    @Environment(\.appTheme) private var theme
    
    let message: String?
    
    public init(message: String? = nil) {
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: theme.spacingMD) {
            ProgressView()
                .tint(theme.primaryColor)
            
            if let message {
                Text(message)
                    .font(theme.fontBody)
                    .foregroundColor(theme.textSecondaryColor)
            }
        }
        .padding(theme.spacingXL)
    }
}
