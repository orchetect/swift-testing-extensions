// swift-tools-version: 6.0

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swift-testing-extensions",
    platforms: [.macOS(.v10_15), .macCatalyst(.v13), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(
            name: "TestingExtensions",
            targets: ["TestingExtensions"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "600.0.0" ..< "99999999.999.999")
    ],
    targets: [
        .target(
            name: "TestingExtensions",
            dependencies: ["TestingExtensionsMacros"],
            resources: [.copy("TestResource/Base/.testResourceFolder")]
        ),
        .macro(
            name: "TestingExtensionsMacros",
            dependencies: [
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax")
            ]
        ),
        .testTarget(
            name: "TestingExtensionsTests",
            dependencies: [
                "TestingExtensions",
                "TestingExtensionsMacros",
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
            ],
            resources: [.copy("TestResource/ResourceFiles")]
        )
    ]
)
