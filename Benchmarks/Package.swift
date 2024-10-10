// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Benchmarks",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        // dsls
        .package(url: "https://github.com/ordo-one/package-benchmark", from: "1.27.0"),
        .package(name: "swift-htmlkit", path: "../"),
        .package(url: "https://github.com/sliemeobn/elementary", from: "0.3.4"),
        .package(url: "https://github.com/vapor-community/HTMLKit", from: "2.8.1"),
        .package(url: "https://github.com/pointfreeco/swift-html", from: "0.4.1"),
        .package(url: "https://github.com/RandomHashTags/fork-bb-swift-html", branch: "main"),
        .package(url: "https://github.com/JohnSundell/Plot", from: "0.14.0"),
        //.package(url: "https://github.com/toucansites/toucan", from: "1.0.0-alpha.1"), // unstable
        .package(url: "https://github.com/RandomHashTags/fork-Swim", branch: "main"),
        .package(url: "https://github.com/dokun1/Vaux", from: "0.2.0"),
        .package(url: "https://github.com/vapor/leaf", from: "4.4.0"),

        // networking
        .package(url: "https://github.com/vapor/vapor", from: "4.106.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "Utilities",
            path: "Benchmarks/Utilities"
        ),
        .target(
            name: "TestElementary",
            dependencies: [
                "Utilities",
                .product(name: "Elementary", package: "Elementary"),
            ],
            path: "Benchmarks/Elementary"
        ),
        .target(
            name: "TestLeaf",
            dependencies: [
                "Utilities",
                .product(name: "Leaf", package: "Leaf")
            ],
            path: "Benchmarks/Leaf"
        ),
        .target(
            name: "TestPlot",
            dependencies: [
                "Utilities",
                .product(name: "Plot", package: "Plot")
            ],
            path: "Benchmarks/Plot"
        ),
        .target(
            name: "TestSwiftHTMLBB",
            dependencies: [
                "Utilities",
                .product(name: "SwiftHtml", package: "fork-bb-swift-html")
            ],
            path: "Benchmarks/SwiftHTMLBB"
        ),
        .target(
            name: "TestSwiftHTMLKit",
            dependencies: [
                "Utilities",
                .product(name: "HTMLKit", package: "swift-htmlkit", moduleAliases: ["HTMLKit" : "SwiftHTMLKit"]),
                .product(name: "HTMLKit", package: "HTMLKit", moduleAliases: ["HTMLKit" : "VaporHTMLKit"])
            ],
            path: "Benchmarks/SwiftHTMLKit"
        ),
        .target(
            name: "TestSwiftHTMLPF",
            dependencies: [
                "Utilities",
                .product(name: "Html", package: "swift-html")
            ],
            path: "Benchmarks/SwiftHTMLPF"
        ),
        .target(
            name: "TestSwim",
            dependencies: [
                "Utilities",
                .product(name: "Swim", package: "fork-Swim")
            ],
            path: "Benchmarks/Swim"
        ),
        .target(
            name: "TestToucan",
            dependencies: [
                "Utilities"
            ],
            path: "Benchmarks/Toucan"
        ),
        .target(
            name: "TestVaporHTMLKit",
            dependencies: [
                "Utilities",
                .product(name: "HTMLKit", package: "swift-htmlkit", moduleAliases: ["HTMLKit" : "SwiftHTMLKit"]),
                .product(name: "HTMLKit", package: "HTMLKit", moduleAliases: ["HTMLKit" : "VaporHTMLKit"])
            ],
            path: "Benchmarks/VaporHTMLKit"
        ),
        .target(
            name: "TestVaux",
            dependencies: [
                "Utilities",
                .product(name: "Vaux", package: "Vaux")
            ],
            path: "Benchmarks/Vaux"
        ),

        .testTarget(
            name: "UnitTests",
            dependencies: [
                "Utilities",
                .product(name: "HTMLKit", package: "swift-htmlkit", moduleAliases: ["HTMLKit" : "SwiftHTMLKit"]),
                .product(name: "HTMLKit", package: "HTMLKit", moduleAliases: ["HTMLKit" : "VaporHTMLKit"]),

                "TestElementary",
                "TestLeaf",
                "TestPlot",
                "TestSwiftHTMLBB",
                "TestSwiftHTMLKit",
                "TestSwiftHTMLPF",
                "TestSwim",
                "TestToucan",
                "TestVaporHTMLKit",
                "TestVaux",
            ],
            path: "Benchmarks/UnitTests"
        ),

        .executableTarget(
            name: "Benchmarks",
            dependencies: [
                "Utilities",
                "TestElementary",
                "TestLeaf",
                "TestPlot",
                "TestSwiftHTMLBB",
                "TestSwiftHTMLKit",
                "TestSwiftHTMLPF",
                "TestSwim",
                "TestToucan",
                "TestVaporHTMLKit",
                "TestVaux",
                .product(name: "Benchmark", package: "package-benchmark")
            ],
            path: "Benchmarks/Benchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
            ]
        )
    ]
)
