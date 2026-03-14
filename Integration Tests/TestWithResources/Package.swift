// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TestWithResources",
    products: [
        .library(
            name: "TestWithResources",
            targets: ["TestWithResources"]
        )
    ],
    dependencies: [
        .package(path: "../../"),
    ],
    targets: [
        .target(
            name: "TestWithResources"
        ),
        .testTarget(
            name: "TestWithResourcesTests",
            dependencies: [
                "TestWithResources",
                .product(name: "TestingExtensions", package: "swift-testing-extensions"),
            ],
            resources: [.copy("TestResource/Text Files")]
        )
    ]
)
