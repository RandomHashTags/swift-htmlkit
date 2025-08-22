// swift-tools-version:5.9

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
        .library(name: "HTMLKit",  targets: ["HTMLKit"]),
        .library(name: "HTMLKitParse", targets: ["HTMLKitParse"])
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
                "HTMLKitUtilityMacros"
            ]
        ),

        .target(
            name: "CSS",
            dependencies: [
                "HTMLKitUtilities"
            ]
        ),
        .target(
            name: "HTMX",
            dependencies: [
                "HTMLKitUtilities"
            ]
        ),

        .target(
            name: "HTMLAttributes",
            dependencies: [
                "CSS",
                "HTMX",
                "HTMLKitUtilities"
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
                "CSS",
                "HTMLAttributes",
                "HTMLElements",
                "HTMLKitUtilities",
                "HTMX",
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
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
                "CSS",
                "HTMLAttributes",
                "HTMLElements",
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