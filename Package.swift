// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-htmlkit",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .visionOS(.v1),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "HTMLKit",
            targets: ["HTMLKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.1")
    ],
    targets: [
        .macro(
            name: "HTMLKitUtilityMacros",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),

        .target(
            name: "HTMLKitUtilities",
            dependencies: [
                "HTMLKitUtilityMacros",
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),

        .target(
            name: "CSS",
            dependencies: [
                "HTMLKitUtilities",
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),
        .target(
            name: "HTMX",
            dependencies: [
                "HTMLKitUtilities",
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),

        .target(
            name: "HTMLAttributes",
            dependencies: [
                "CSS",
                "HTMX",
                "HTMLKitUtilities",
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),

        .target(
            name: "HTMLElements",
            dependencies: [
                "HTMLKitUtilities",
                "HTMLAttributes",
                "CSS",
                "HTMX"
            ]
        ),

        .target(
            name: "HTMLKitParse",
            dependencies: [
                "HTMLElements"
            ]
        ),

        .macro(
            name: "HTMLKitMacros",
            dependencies: [
                "HTMLKitParse",
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),
        .target(
            name: "HTMLKit",
            dependencies: [
                "HTMLAttributes",
                "HTMLKitUtilities",
                "HTMLKitMacros"
            ]
        ),

        .testTarget(
            name: "HTMLKitTests",
            dependencies: ["HTMLKit", "HTMLAttributes", "HTMLElements"]
        ),
    ]
)

for target in package.targets {
    target.swiftSettings = [
        .enableExperimentalFeature("StrictConcurrency")
    ]
}