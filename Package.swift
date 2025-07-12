// swift-tools-version:6.1

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-htmlkit",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .visionOS(.v1),
        .watchOS(.v9)
    ],
    products: [
        .library(
            name: "HTMLKit",
            targets: ["HTMLKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.1"),
        .package(url: "https://github.com/coenttb/swift-html-types", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-css-types", branch: "main")
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
                .product(name: "CSSTypes", package: "swift-css-types"),
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
                .product(name: "CSSTypes", package: "swift-css-types"),
                "HTMX",
                .product(name: "HTMLElementTypes", package: "swift-html-types")
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
                //.product(name: "SwiftLexicalLookup", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),
        .target(
            name: "HTMLKit",
            dependencies: [
                .product(name: "CSSTypes", package: "swift-css-types"),
                "HTMLAttributes",
                "HTMLElements",
                "HTMLKitParse",
                "HTMLKitUtilities",
                "HTMLKitMacros",
                "HTMX"
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