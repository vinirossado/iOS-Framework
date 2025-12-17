// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VRFoundation",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "VRStateManagement", targets: ["VRStateManagement"]),
        .library(name: "VRNetworking", targets: ["VRNetworking"]),
        .library(name: "VRCaching", targets: ["VRCaching"]),
        .library(name: "VRAuthentication", targets: ["VRAuthentication"]),
        .library(name: "VRUIComponents", targets: ["VRUIComponents"]),
        .library(name: "VRFoundation", targets: ["VRStateManagement", "VRNetworking", "VRCaching", "VRAuthentication", "VRUIComponents"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "9.0.0"),
    ],
    targets: [
        .target(
            name: "VRStateManagement",
            dependencies: [],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .target(
            name: "VRNetworking",
            dependencies: ["Alamofire", "VRStateManagement"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .target(
            name: "VRCaching",
            dependencies: ["VRNetworking"],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .target(
            name: "VRAuthentication",
            dependencies: ["VRNetworking", .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        ),
        .target(
            name: "VRUIComponents",
            dependencies: ["VRStateManagement"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "VRStateManagementTests", dependencies: ["VRStateManagement"]),
        .testTarget(name: "VRNetworkingTests", dependencies: ["VRNetworking"]),
        .testTarget(name: "VRCachingTests", dependencies: ["VRCaching"]),
        .testTarget(name: "VRAuthenticationTests", dependencies: ["VRAuthentication"]),
        .testTarget(name: "VRUIComponentsTests", dependencies: ["VRUIComponents"]),
    ]
)
