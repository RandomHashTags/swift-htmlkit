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
        .package(url: "https://github.com/RandomHashTags/swift-htmlkit", from: "0.4.0"),
        .package(url: "https://github.com/sliemeobn/elementary", from: "0.3.4"),
        .package(url: "https://github.com/vapor-community/HTMLKit", from: "2.8.1"),
        .package(url: "https://github.com/pointfreeco/swift-html", from: "0.4.1"),
        //.package(name: "BBHTML", url: "https://github.com/BinaryBirds/swift-html", from: "1.7.0")
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
            name: "TestSwiftHTMLBB",
            dependencies: [
                "Utilities",
                //.product(name: "SwiftHtml", package: "BBHTML")
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
                .product(name: "Html", package: "swift-html"),
            ],
            path: "Benchmarks/SwiftHTMLPF"
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

        .executableTarget(
            name: "Benchmarks",
            dependencies: [
                "TestElementary",
                "TestSwiftHTMLBB",
                "TestSwiftHTMLKit",
                "TestSwiftHTMLPF",
                "TestVaporHTMLKit",
                .product(name: "Benchmark", package: "package-benchmark")
            ],
            path: "Benchmarks/Benchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
            ]
        )
    ]
)
