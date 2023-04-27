// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "swift-analyzer",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-syntax", from: "508.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "swift-analyzer",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)
