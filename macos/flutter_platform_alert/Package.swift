// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_platform_alert",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "flutter-platform-alert", targets: ["flutter_platform_alert"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "flutter_platform_alert",
            dependencies: [],
            resources: [
               .process("Resources"),
            ]
        )
    ]
)
