// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DependencyTest",
    products: [
        .library(
            name: "DependencyTest",
            targets: ["DependencyTest"]
        )
    ],
    dependencies: [
        .package(path: "../../"),
    ],
    targets: [
        .target(
            name: "DependencyTest"
        ),
        .testTarget(
            name: "DependencyTestTests",
            dependencies: [
                "DependencyTest",
                .product(name: "TestingExtensions", package: "swift-testing-extensions"),
            ],
            resources: [.copy("TestResource/Text Files")]
        )
    ]
)
