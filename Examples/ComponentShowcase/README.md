# 📚 Component Storybook

A visual catalog/storybook for all VRUIComponents in the iOS-Framework.

## 🎯 Purpose

This Storybook allows you to:
- **Visualize** all components in isolation
- **Test** components with different themes (Light/Dark)
- **Document** component usage and variations
- **Design** new features by seeing all components in one place

## 🚀 How to Use

### Option 1: SwiftUI Preview (Recommended)

1. Open `ComponentStorybook.swift` in Xcode
2. Enable Canvas (Cmd + Option + Enter)
3. Click the "Play" button on the preview
4. Navigate through different component categories

### Option 2: Add to Your Project

1. Copy `ComponentStorybook.swift` to your project
2. Add it to a debug-only target
3. Navigate to `ComponentStorybook()` view from your app during development

### Option 3: Standalone Demo App

Create a new iOS app in Xcode and use ComponentStorybook as the root view:

```swift
import SwiftUI
import VRUIComponents

@main
struct StorybookApp: App {
    var body: some Scene {
        WindowGroup {
            ComponentStorybook()
        }
    }
}
```

## 📦 What's Included

### Components
- ✅ **Banners** - Success, Error, Warning, Info toasts
- ✅ **Cards** - Content containers with shadows
- ✅ **Dialogs** - Modal dialogs (destructive, etc.)
- ✅ **Loading** - Loading indicators

### Design Tokens
- ✅ **Color Palette** - All theme colors
- ✅ **Typography** - Font styles
- ✅ **Spacing** - Spacing scale

### Themes
- 🌞 **Light Theme**
- 🌙 **Dark Theme**

## 🎨 Customization

To use your custom theme instead of `DefaultTheme`:

```swift
enum StoryTheme {
    var appTheme: AppTheme {
        switch self {
        case .light: return YourLightTheme()
        case .dark: return YourDarkTheme()
        }
    }
}
```

## 📝 Adding New Components

1. Create a new example view:
```swift
struct YourComponentExamples: View {
    let theme: StoryTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Your Component", description: "Description")
            
            ComponentExample(title: "Default") {
                YourComponent()
                    .environment(\.appTheme, theme.appTheme)
            }
        }
    }
}
```

2. Add to `ComponentCategory` enum
3. Add case to `CategoryView` switch

## 🔧 Requirements

- iOS 17.0+
- VRUIComponents package
- VRStateManagement package

## 💡 Tips

- Use the theme switcher (top right) to test components in both themes
- Each component example is isolated - you can copy the code directly
- Banner examples have "Show Again" buttons for repeated testing

---

**Happy Component Building! 🚀**
