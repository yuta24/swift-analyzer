// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swift-analyzer",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "swift-analyzer", targets: ["SwiftAnalyzer"])],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-syntax", from: "508.0.0"),
    ],
    targets: [
        .target(
            name: "CodeMetrics",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxParser", package: "swift-syntax"),
            ]
        ),
        .executableTarget(
            name: "SwiftAnalyzer",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "CodeMetrics"),
            ]
        ),
    ]
)
