import SwiftUI

/// Customizable loading view
public struct LoadingView: View {
    @Environment(\.appTheme) private var theme
    
    let message: String?
    
    public init(message: String? = nil) {
        self.message = message
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .tint(.blue)
            
            if let message {
                Text(message)
                    .font(.body)
                    .foregroundColor(theme.textSecondaryColor)
            }
        }
        .padding(32)
    }
}
