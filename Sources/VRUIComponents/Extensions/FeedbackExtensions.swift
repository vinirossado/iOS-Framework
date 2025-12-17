//
//  FeedbackExtensions.swift
//  VRUIComponents
//
//  Convenience extensions for VRStateManagement feedback types
//  Add this file to: Sources/VRUIComponents/Extensions/FeedbackExtensions.swift
//

import Foundation
import VRStateManagement

// MARK: - ErrorBanner Convenience Extensions

extension ErrorBanner {
    /// Create an ErrorBanner from any Error with optional context
    /// 
    /// This extension makes it easy to convert standard Swift errors into user-friendly error banners.
    /// If the error conforms to LocalizedError, the recoverySuggestion will be included.
    ///
    /// Example:
    /// ```swift
    /// do {
    ///     try await someOperation()
    /// } catch {
    ///     feedbackState = .error(ErrorBanner(from: error, context: "Delete Trip"))
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - error: The error to convert
    ///   - context: Optional context string to use as the banner title (defaults to "Error")
    public init(from error: Error, context: String = "") {
        let localizedError = error as? LocalizedError
        
        self.init(
            title: context.isEmpty ? "Error" : context,
            message: error.localizedDescription,
            recoverySuggestion: localizedError?.recoverySuggestion,
            context: context
        )
    }
}
