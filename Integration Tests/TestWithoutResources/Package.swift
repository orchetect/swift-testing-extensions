// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TestWithoutResources",
    products: [
        .library(
            name: "TestWithoutResources",
            targets: ["TestWithoutResources"]
        )
    ],
    dependencies: [
        .package(path: "../../"),
    ],
    targets: [
        .target(
            name: "TestWithoutResources"
        ),
        .testTarget(
            name: "TestWithoutResourcesTests",
            dependencies: [
                "TestWithoutResources",
                .product(name: "TestingExtensions", package: "swift-testing-extensions"),
            ]
        )
    ]
)
