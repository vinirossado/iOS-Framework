# VRFoundation

A modern Swift 6+ framework for iOS development with strict concurrency, typed throws, and comprehensive UI theming.

## 🎯 Overview

VRFoundation is a collection of reusable modules designed to accelerate iOS app development with modern Swift features:

- **Type-safe state management** with enum-based patterns
- **Customizable UI components** with complete theming system
- **Modern networking layer** with ETag support and typed throws
- **Swift 6+ concurrency** with strict checking enabled
- **Plug-and-play architecture** - use only what you need

## 📦 Modules

### VRStateManagement
Reusable state patterns using Swift 6+ enums with associated values.

**Features:**
- `FeedbackState` - Error/Success/Dialog state machine
- `LoadState<T>` - Generic loading state with data
- `UploadState` - File upload progress tracking
- All enums are `@frozen` for performance
- Full `Sendable` conformance

### VRUIComponents
Customizable UI components with complete theming support.

**Features:**
- Theme protocol system for app-wide styling
- `BannerView` - Feedback banners (error, success, warning, info)
- `Card` - Generic card component
- `LoadingView` - Themed loading indicator
- Environment-based theme injection

### VRNetworking
Modern API layer with typed throws and ETag support.

**Features:**
- `throws(APIError)` typed errors for compile-time safety
- Built-in ETag support for efficient caching
- Automatic 401 retry with token refresh
- Generic response decoding
- Development SSL certificate trust

## 🚀 Installation

### Swift Package Manager

Add VRFoundation to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/vinirossado/iOS-Framework.git", from: "1.0.0")
]
```

Or in Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/vinirossado/iOS-Framework.git`
3. Select the modules you need

## 📖 Quick Start

### Using VRStateManagement

```swift
import VRStateManagement

@Observable
class MyViewModel {
    var feedbackState: FeedbackState = .none
    
    func performAction() async {
        do {
            try await someOperation()
            feedbackState = .success(SuccessBanner(message: "Success!"))
        } catch {
            feedbackState = .error(ErrorBanner(message: error.localizedDescription))
        }
    }
}
```

### Using VRUIComponents with Theming

```swift
import SwiftUI
import VRUIComponents

// 1. Create your custom theme
struct MyAppTheme: AppTheme {
    var primaryColor: Color = Color(hex: "4A90E2")
    var fontTitle: Font = .custom("Avenir-Heavy", size: 24)
    var cornerRadiusMD: CGFloat = 16
    // ... customize all theme properties
}

// 2. Apply theme to your app
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .theme(MyAppTheme())
        }
    }
}

// 3. Use themed components
struct ContentView: View {
    @State private var feedbackState: FeedbackState = .none
    
    var body: some View {
        VStack {
            Card {
                Text("Hello, World!")
            }
            
            LoadingView(message: "Loading...")
        }
        .banner(feedbackState: $feedbackState)
    }
}
```

### Using VRNetworking

```swift
import VRNetworking

// 1. Define your API models
struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

// 2. Create API service
let apiService = APIService(
    baseURL: "https://api.example.com/v1/"
)

// 3. Make requests with typed throws
do {
    let response = try await apiService.request(
        APIEndpoint(path: "users/me", method: .GET),
        responseType: User.self
    )
    
    if let user = response.data {
        print("User: \(user.name)")
    }
} catch let error as APIError {
    // Type-safe error handling!
    switch error {
    case .unauthorized(let message):
        print("Auth failed: \(message ?? "")")
    case .notFound:
        print("User not found")
    case .networkError(let error):
        print("Network error: \(error)")
    default:
        print("Error: \(error.errorDescription ?? "")")
    }
}
```

## 🎨 Theming System

The theme system allows complete customization of all UI components:

```swift
public protocol AppTheme {
    // Colors
    var primaryColor: Color { get }
    var errorColor: Color { get }
    var successColor: Color { get }
    
    // Typography
    var fontTitle: Font { get }
    var fontBody: Font { get }
    
    // Spacing
    var spacingMD: CGFloat { get }
    var spacingLG: CGFloat { get }
    
    // Borders
    var cornerRadiusMD: CGFloat { get }
    
    // Shadows
    var shadowColor: Color { get }
    var shadowRadius: CGFloat { get }
}
```

All components automatically use your theme via `@Environment(\.appTheme)`.

## ✨ Key Features

### Swift 6+ Modern Features
- ✅ **Typed Throws** - `throws(APIError)` for compile-time error safety
- ✅ **@frozen Enums** - Performance optimization and ABI stability
- ✅ **Strict Concurrency** - Full Sendable conformance
- ✅ **Actor Isolation** - @MainActor where needed

### Type-Safe State Management
- ✅ **Enum-based states** - Impossible states are impossible
- ✅ **Associated values** - Type-safe data in states
- ✅ **Computed properties** - Convenient state checks

### Production Ready
- ✅ **Comprehensive error handling**
- ✅ **ETag caching support**
- ✅ **Automatic token refresh**
- ✅ **Development/Production modes**

## 📋 Requirements

- iOS 17.0+
- macOS 14.0+
- Swift 6.0+
- Xcode 16.0+

## 📄 License

MIT License - See LICENSE file for details

## 👨‍💻 Author

Vinicius Rossado - [@vinirossado](https://github.com/vinirossado)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
