// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-htmlkit",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "HTMLKit",
            targets: ["HTMLKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.75.0")
    ],
    targets: [
        .target(
            name: "HTMLKitUtilities",
            dependencies: [
                .product(name: "NIOCore", package: "swift-nio")
            ]
        ),
        .macro(
            name: "HTMLKitMacros",
            dependencies: [
                "HTMLKitUtilities",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax")
            ]
        ),
        .target(
            name: "HTMLKit",
            dependencies: [
                "HTMLKitUtilities",
                "HTMLKitMacros"
            ]
        ),

        .testTarget(
            name: "HTMLKitTests",
            dependencies: ["HTMLKit"]
        ),
    ]
)
