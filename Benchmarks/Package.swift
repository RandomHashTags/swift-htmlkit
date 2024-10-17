// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Benchmarks",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/ordo-one/package-benchmark", from: "1.27.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "600.0.0"),
        // dsls
        .package(name: "swift-htmlkit", path: "../"),
        .package(url: "https://github.com/sliemeobn/elementary", exact: "0.4.1"),
        .package(url: "https://github.com/vapor-community/HTMLKit", exact: "2.8.1"),
        .package(url: "https://github.com/pointfreeco/swift-html", exact: "0.4.1"),
        .package(url: "https://github.com/RandomHashTags/fork-bb-swift-html", branch: "main"),
        .package(url: "https://github.com/JohnSundell/Plot", exact: "0.14.0"),
        //.package(url: "https://github.com/toucansites/toucan", from: "1.0.0-alpha.1"), // unstable
        .package(url: "https://github.com/robb/Swim", exact: "0.4.0"),
        .package(url: "https://github.com/RandomHashTags/fork-Vaux", branch: "master"),
        .package(url: "https://github.com/RandomHashTags/fork-swift-dom", branch: "master"),
        //.package(url: "https://github.com/TokamakUI/Tokamak", from: "0.11.1"), // swift-benchmark problem

        .package(url: "https://github.com/vapor/leaf", exact: "4.4.0"),

        // networking
        .package(url: "https://github.com/apple/swift-nio", from: "2.75.0"),
        .package(url: "https://github.com/vapor/vapor", from: "4.106.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird", from: "2.1.0")
    ],
    targets: [
        .target(
            name: "Utilities",
            dependencies: [
                .product(name: "NIOCore", package: "swift-nio")
            ],
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
            name: "TestSwiftDOM",
            dependencies: [
                "Utilities",
                .product(name: "DOM", package: "fork-swift-dom", moduleAliases: ["DOM":"SwiftDOM"])
            ],
            path: "Benchmarks/SwiftDOM"
        ),
        .target(
            name: "TestSwiftHTMLBB",
            dependencies: [
                "Utilities",
                .product(name: "SwiftHtml", package: "fork-bb-swift-html", moduleAliases: ["SwiftHtml":"SwiftHTMLBB"])
            ],
            path: "Benchmarks/SwiftHTMLBB"
        ),
        .target(
            name: "TestSwiftHTMLKit",
            dependencies: [
                "Utilities",
                .product(name: "HTMLKit", package: "swift-htmlkit", moduleAliases: ["HTMLKit":"SwiftHTMLKit"]),
                .product(name: "HTMLKit", package: "HTMLKit", moduleAliases: ["HTMLKit":"VaporHTMLKit"])
            ],
            path: "Benchmarks/SwiftHTMLKit"
        ),
        .target(
            name: "TestSwiftHTMLPF",
            dependencies: [
                "Utilities",
                .product(name: "Html", package: "swift-html", moduleAliases: ["Html":"SwiftHTMLPF"])
            ],
            path: "Benchmarks/SwiftHTMLPF"
        ),
        .target(
            name: "TestSwim",
            dependencies: [
                "Utilities",
                .product(name: "Swim", package: "Swim"),
                .product(name: "HTML", package: "Swim", moduleAliases: ["HTML":"SwimHTML"])
            ],
            path: "Benchmarks/Swim"
        ),
        .target(
            name: "TestTokamak",
            dependencies: [
                "Utilities",
                //.product(name: "TokamakDOM", package: "Tokamak"),
                //.product(name: "TokamakStaticHTML", package: "Tokamak")
            ],
            path: "Benchmarks/Tokamak"
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
                .product(name: "HTMLKit", package: "HTMLKit", moduleAliases: ["HTMLKit":"VaporHTMLKit"]),
                .product(name: "HTMLKit", package: "swift-htmlkit", moduleAliases: ["HTMLKit":"SwiftHTMLKit"])
            ],
            path: "Benchmarks/VaporHTMLKit"
        ),
        .target(
            name: "TestVaux",
            dependencies: [
                "Utilities",
                .product(name: "Vaux", package: "fork-vaux")
            ],
            path: "Benchmarks/Vaux"
        ),
        .executableTarget(
            name: "Networking",
            dependencies: [
                "Utilities",

                "TestElementary",
                "TestLeaf",
                "TestPlot",
                "TestSwiftDOM",
                "TestSwiftHTMLBB",
                "TestSwiftHTMLKit",
                "TestSwiftHTMLPF",
                "TestSwim",
                "TestToucan",
                "TestVaporHTMLKit",
                "TestVaux",
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Hummingbird", package: "hummingbird")
            ],
            path: "Benchmarks/Networking"
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
                "TestSwiftDOM",
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
                "TestSwiftDOM",
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
