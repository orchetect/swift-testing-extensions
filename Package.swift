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
            dependencies: ["TestingExtensionsMacros"]
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
                .target(name: "TestingExtensionsMacros", condition: .when(platforms: [.macOS])),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax", condition: .when(platforms: [.macOS])),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax", condition: .when(platforms: [.macOS]))
            ],
            resources: [.copy("TestResource/ResourceFiles")]
        )
    ]
)

#if !canImport(Darwin)
// Data compression dependency for Linux and Windows where Apple's NSData compression isn't available.
package.dependencies.append(
    .package(url: "https://github.com/tsolomko/SWCompression", from: "4.8.6")
)
package.targets.first(where: { $0.name == "TestingExtensions" })?.dependencies.append(
    "SWCompression"
)

// Data parsing dependency
package.dependencies.append(
    .package(url: "https://github.com/orchetect/swift-data-parsing", from: "0.1.0")
)
package.targets.first(where: { $0.name == "TestingExtensions" })?.dependencies.append(
    .product(name: "SwiftDataParsing", package: "swift-data-parsing")
)
#endif
