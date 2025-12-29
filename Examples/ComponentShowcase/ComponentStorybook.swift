//
//  ComponentStorybook.swift
//  iOS-Framework Examples
//
//  Storybook/Catalog for all VRUIComponents
//  Run this in a SwiftUI Preview or Demo App to visualize all components
//

import SwiftUI
import VRUIComponents
import VRStateManagement

// MARK: - Storybook Main View

struct ComponentStorybook: View {
    @State private var selectedCategory: ComponentCategory = .banners
    @State private var selectedTheme: StoryTheme = .light
    
    var body: some View {
        NavigationView {
            List {
                ForEach(ComponentCategory.allCases) { category in
                    NavigationLink(destination: CategoryView(category: category, theme: selectedTheme)) {
                        Label(category.title, systemImage: category.icon)
                    }
                }
            }
            .navigationTitle("Component Storybook")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Theme", selection: $selectedTheme) {
                            ForEach(StoryTheme.allCases) { theme in
                                Label(theme.name, systemImage: theme.icon)
                                    .tag(theme)
                            }
                        }
                    } label: {
                        Image(systemName: selectedTheme.icon)
                    }
                }
            }
        }
    }
}

// MARK: - Category View

struct CategoryView: View {
    let category: ComponentCategory
    let theme: StoryTheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                switch category {
                case .banners:
                    BannerExamples(theme: theme)
                case .cards:
                    CardExamples(theme: theme)
                case .dialogs:
                    DialogExamples(theme: theme)
                case .loading:
                    LoadingExamples(theme: theme)
                case .colorPalette:
                    ColorPaletteExamples(theme: theme)
                case .typography:
                    TypographyExamples(theme: theme)
                case .spacing:
                    SpacingExamples(theme: theme)
                }
            }
            .padding()
        }
        .navigationTitle(category.title)
        .background(theme.backgroundColor)
    }
}

// MARK: - Banner Examples

struct BannerExamples: View {
    let theme: StoryTheme
    @State private var showSuccessBanner = true
    @State private var showErrorBanner = true
    @State private var showWarningBanner = true
    @State private var showInfoBanner = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Banners / Toasts", description: "Feedback messages for users")
            
            VStack(spacing: 16) {
                ComponentExample(title: "Success Banner") {
                    if showSuccessBanner {
                        BannerView(
                            type: .success,
                            title: "Success!",
                            message: "Your changes have been saved successfully",
                            onDismiss: { showSuccessBanner = false }
                        )
                        .environment(\.appTheme, theme.appTheme)
                    } else {
                        Button("Show Again") { showSuccessBanner = true }
                    }
                }
                
                ComponentExample(title: "Error Banner") {
                    if showErrorBanner {
                        BannerView(
                            type: .error,
                            title: "Error",
                            message: "Failed to connect to server. Please try again.",
                            onDismiss: { showErrorBanner = false }
                        )
                        .environment(\.appTheme, theme.appTheme)
                    } else {
                        Button("Show Again") { showErrorBanner = true }
                    }
                }
                
                ComponentExample(title: "Warning Banner") {
                    if showWarningBanner {
                        BannerView(
                            type: .warning,
                            title: "Warning",
                            message: "Your session will expire in 5 minutes",
                            onDismiss: { showWarningBanner = false }
                        )
                        .environment(\.appTheme, theme.appTheme)
                    } else {
                        Button("Show Again") { showWarningBanner = true }
                    }
                }
                
                ComponentExample(title: "Info Banner") {
                    if showInfoBanner {
                        BannerView(
                            type: .info,
                            title: "Info",
                            message: "A new version is available for download",
                            onDismiss: { showInfoBanner = false }
                        )
                        .environment(\.appTheme, theme.appTheme)
                    } else {
                        Button("Show Again") { showInfoBanner = true }
                    }
                }
            }
        }
    }
}

// MARK: - Card Examples

struct CardExamples: View {
    let theme: StoryTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Cards", description: "Containers for content")
            
            VStack(spacing: 16) {
                ComponentExample(title: "Default Card") {
                    Card {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Card Title")
                                .font(.headline)
                            Text("This is a default card with shadow and rounded corners.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .environment(\.appTheme, theme.appTheme)
                }
                
                ComponentExample(title: "Card without Shadow") {
                    Card(shadowEnabled: false) {
                        Text("Card without shadow")
                            .padding()
                    }
                    .environment(\.appTheme, theme.appTheme)
                }
                
                ComponentExample(title: "Custom Padding & Radius") {
                    Card(padding: 24, cornerRadius: 20) {
                        Text("Custom padding (24) and corner radius (20)")
                    }
                    .environment(\.appTheme, theme.appTheme)
                }
            }
        }
    }
}

// MARK: - Dialog Examples

struct DialogExamples: View {
    let theme: StoryTheme
    @State private var showDestructiveDialog = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Dialogs", description: "Modal dialogs for user interaction")
            
            ComponentExample(title: "Destructive Dialog") {
                Button("Show Destructive Dialog") {
                    showDestructiveDialog = true
                }
                .sheet(isPresented: $showDestructiveDialog) {
                    CustomDialogView(
                        dialog: CustomDialog.destructive(
                            title: "Delete Item",
                            message: "Are you sure you want to delete this item? This action cannot be undone.",
                            confirmTitle: "Delete",
                            onConfirm: {
                                showDestructiveDialog = false
                                print("Item deleted")
                            }
                        ),
                        onDismiss: { showDestructiveDialog = false }
                    )
                    .environment(\.appTheme, theme.appTheme)
                    .presentationDetents([.medium])
                }
            }
        }
    }
}

// MARK: - Loading Examples

struct LoadingExamples: View {
    let theme: StoryTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Loading Indicators", description: "Loading states and spinners")
            
            ComponentExample(title: "Default Loading") {
                LoadingView()
                    .environment(\.appTheme, theme.appTheme)
                    .frame(height: 100)
            }
        }
    }
}

// MARK: - Color Palette Examples

struct ColorPaletteExamples: View {
    let theme: StoryTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Color Palette", description: "Theme colors from AppTheme")
            
            VStack(spacing: 12) {
                ColorSwatch(name: "Error", color: theme.appTheme.errorColor)
                ColorSwatch(name: "Success", color: theme.appTheme.successColor)
                ColorSwatch(name: "Warning", color: theme.appTheme.warningColor)
                ColorSwatch(name: "Info", color: theme.appTheme.infoColor)
                ColorSwatch(name: "Primary", color: theme.appTheme.primaryColor)
                ColorSwatch(name: "Secondary", color: theme.appTheme.secondaryColor)
                ColorSwatch(name: "Accent", color: theme.appTheme.accentColor)
                ColorSwatch(name: "Surface", color: theme.appTheme.surfaceColor)
            }
        }
    }
}

// MARK: - Typography Examples

struct TypographyExamples: View {
    let theme: StoryTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Typography", description: "Font styles from AppTheme")
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Large Title").font(theme.appTheme.fontLargeTitle)
                Text("Title").font(theme.appTheme.fontTitle)
                Text("Title 2").font(theme.appTheme.fontTitle2)
                Text("Title 3").font(theme.appTheme.fontTitle3)
                Text("Headline").font(theme.appTheme.fontHeadline)
                Text("Body").font(theme.appTheme.fontBody)
                Text("Callout").font(theme.appTheme.fontCallout)
                Text("Subheadline").font(theme.appTheme.fontSubheadline)
                Text("Footnote").font(theme.appTheme.fontFootnote)
                Text("Caption").font(theme.appTheme.fontCaption)
                Text("Caption 2").font(theme.appTheme.fontCaption2)
            }
        }
    }
}

// MARK: - Spacing Examples

struct SpacingExamples: View {
    let theme: StoryTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            SectionHeader(title: "Spacing", description: "Spacing values from AppTheme")
            
            VStack(alignment: .leading, spacing: 16) {
                SpacingExample(name: "XS", value: theme.appTheme.spacingXS)
                SpacingExample(name: "SM", value: theme.appTheme.spacingSM)
                SpacingExample(name: "MD", value: theme.appTheme.spacingMD)
                SpacingExample(name: "LG", value: theme.appTheme.spacingLG)
                SpacingExample(name: "XL", value: theme.appTheme.spacingXL)
                SpacingExample(name: "XXL", value: theme.appTheme.spacingXXL)
            }
        }
    }
}

// MARK: - Helper Views

struct SectionHeader: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title2.bold())
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct ComponentExample<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ColorSwatch: View {
    let name: String
    let color: Color
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 60, height: 40)
            Text(name)
                .font(.body)
            Spacer()
            Text(color.description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct SpacingExample: View {
    let name: String
    let value: CGFloat
    
    var body: some View {
        HStack(spacing: 16) {
            Text(name)
                .font(.body)
                .frame(width: 60, alignment: .leading)
            Rectangle()
                .fill(Color.blue)
                .frame(width: value, height: 20)
            Text("\(Int(value))pt")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Supporting Types

enum ComponentCategory: String, CaseIterable, Identifiable {
    case banners, cards, dialogs, loading, colorPalette, typography, spacing
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .banners: return "Banners"
        case .cards: return "Cards"
        case .dialogs: return "Dialogs"
        case .loading: return "Loading"
        case .colorPalette: return "Color Palette"
        case .typography: return "Typography"
        case .spacing: return "Spacing"
        }
    }
    
    var icon: String {
        switch self {
        case .banners: return "bell.badge"
        case .cards: return "rectangle.on.rectangle"
        case .dialogs: return "message"
        case .loading: return "arrow.triangle.2.circlepath"
        case .colorPalette: return "paintpalette"
        case .typography: return "textformat"
        case .spacing: return "ruler"
        }
    }
}

enum StoryTheme: String, CaseIterable, Identifiable {
    case light, dark
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .light: return "Light Theme"
        case .dark: return "Dark Theme"
        }
    }
    
    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .light: return Color(.systemBackground)
        case .dark: return Color(.black)
        }
    }
    
    var appTheme: AppTheme {
        DefaultTheme()
    }
}

// MARK: - Preview

#Preview {
    ComponentStorybook()
}
