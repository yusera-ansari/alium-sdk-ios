// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "alium-sdk-ios",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "alium-sdk-ios",
            targets: ["alium-sdk-ios"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "alium-sdk-ios"),
        .testTarget(
            name: "alium-sdk-iosTests",
            dependencies: ["alium-sdk-ios"]
        ),
    ]
)
