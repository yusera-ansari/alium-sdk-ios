// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "alium_sdk",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "alium_sdk",
            targets: ["alium_sdk"]),

    ],
    
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "alium_sdk",
            path: "alium_sdk",
            resources: [
                .process("alium_sdk/Assets.xcassets")
            ]
        
        ),
        .testTarget(
            name: "alium-sdk-iosTests",
            dependencies: ["alium_sdk"]
        ),
        
    ]
)
