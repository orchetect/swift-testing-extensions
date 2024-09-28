# swift-testing-extensions

[![CI Build Status](https://github.com/orchetect/swift-testing-extensions/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/swift-testing-extensions/actions/workflows/build.yml) [![Platforms - macOS 10.10+ | iOS 9+ | tvOS 9+ | watchOS 2+ | visionOS 1+](https://img.shields.io/badge/platforms-macOS%2010.10+%20|%20iOS%209+%20|%20tvOS%209+%20|%20watchOS%202+%20|%20visionOS%201+-lightgrey.svg?style=flat)](https://developer.apple.com/swift) ![Swift 6](https://img.shields.io/badge/Swift-6-orange.svg?style=flat) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-testing-extensions/blob/main/LICENSE)

Useful Swift Testing extensions for test targets.

## Overview

Currently, the library provides a small but useful set of [Swift Testing](https://github.com/swiftlang/swift-testing) related extensions.

- [Test Conditions](#Test-Conditions)
  - [`#fail`](#fail)
- [Test Resources](#Test-Resources)

## Test Conditions

### #fail

The `#fail` condition is analogous to XCTest's `XCTFail()` method and can be used as a stand-in for its functionality.

This can be useful when standard Swift Testing conditions are not possible:

```swift
enum Foo {
    case bar(String)
}

@Test func fooTest() async throws {
    let foo = Foo.bar("foo")

    // test that variable `foo` is of the correct case,
    // and unwrap its associated value
    guard case let .bar(string) = foo else {
        #fail
        return
    }
    
    #expect(string == "foo")
}
```

It can be used with or without a comment.

```swift
#fail
#fail("Failure reason.")
```

## Test Resources

A simple global `TestResource` namespace and API is provided for accessing test resources in a test target.

This namespace is its own global actor, so it is safe to access from any thread and any test context.

Recommended structure for using ``TestResource``:

1. Create a base `TestResource` folder in your package's test target.
2. Create subfolder(s) within the `TestResource` folder as desired in your package's
   testing target to contain the test resource files.
   - For example, if a folder named "Add the following to your `Package.swift`:
     ```swift
     .testTarget(
         // ...
         resources: [.copy("TestResource/SomeFolder")]
     )
     ```
   > Note:
   >
   > In some cases, naming any of these folders "Resources" may cause build errors.
3. In the `TestResource` folder, create a `TestResource.swift` file where you will declare
   test resource files available in the target.
4. For each file within any subfolder(s) located with the `TestResource` folder,
   declare them individually as static properties.
   
   For example, if a single subfolder named "Text" contains two files `Foo.txt` and `Bar.csv`
   then these would be declared as follows:
   
   ```swift
   extension TestResource {
       static let foo = TestResource.File(
           name: "Foo", ext: "txt", subFolder: "TextFiles"
       )
       static let bar = TestResource.File(
           name: "Bar", ext: "csv", subFolder: "TextFiles"
       )
   }
   ```
5. To utilize these files in unit tests, access them as follows:
   
   Getting a URL to a test resource file:
   ```swift
   let url = try #require(try TestResource.foo.url())
   ```
   
   Directly reading a test resource file's contents:
   ```swift
   let data = try #require(try TestResource.foo.data())
   ```

## Installation: Swift Package Manager (SPM)

### Dependency within an Application

1. Add the package to your Xcode project's test target(s) using Swift Package Manager

   - Select File → Swift Packages → Add Package Dependency
   - Add package using `https://github.com/orchetect/swift-testing-extensions` as the URL.

2. Import the module in your `*.swift` test files where needed.

   ```swift
   import Testing
   import TestingExtensions
   ```

### Dependency within a Swift Package

1. In your `Package.swift` file:

   ```swift
   dependencies: [
       .package(url: "https://github.com/orchetect/swift-testing-extensions", from: "0.1.0")
   ]
   ```
   
   In each of your test target(s):
   
   ```swift
   dependencies: [
       .product(name: "TestingExtensions", package: "swift-testing-extensions")
   ]
   ```
   
2. Import the module in your `*.swift` test files where needed.

   ```swift
   import Testing
   import TestingExtensions
   ```

Most methods are implemented as category methods so they are generally discoverable.

All methods have inline help explaining their purpose and basic usage examples.

## Roadmap

Additional methods may be added over time on an as-needed basis.

Since Swift Testing is multiplatform, additional platforms may be supported in future, including Linux and/or Windows.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/swift-testing-extensions/blob/master/LICENSE) for details.

This package has no affiliation with the [Swift Testing](https://github.com/swiftlang/swift-testing) project but is offered as-is for use in conjunction with it.

## Contributions

Bug fixes and improvements are welcome. Please open an issue to discuss prior to submitting PRs.

