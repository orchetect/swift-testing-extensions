# swift-testing-extensions

[![CI Build Status](https://github.com/orchetect/swift-testing-extensions/actions/workflows/build.yml/badge.svg)](https://github.com/orchetect/swift-testing-extensions/actions/workflows/build.yml) [![Platforms - macOS 10.10+ | iOS 9+ | tvOS 9+ | watchOS 2+ | visionOS 1+](https://img.shields.io/badge/platforms-macOS%2010.10+%20|%20iOS%209+%20|%20tvOS%209+%20|%20watchOS%202+%20|%20visionOS%201+-lightgrey.svg?style=flat)](https://developer.apple.com/swift) ![Swift 6](https://img.shields.io/badge/Swift-6-orange.svg?style=flat) [![Xcode 16](https://img.shields.io/badge/Xcode-16-blue.svg?style=flat)](https://developer.apple.com/swift) [![License: MIT](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-testing-extensions/blob/main/LICENSE)

Useful Swift Testing extensions for test targets.

## Overview

Currently, the library provides a small but useful set of [Swift Testing](https://github.com/swiftlang/swift-testing) related extensions.

- [Test Conditions](#Test-Conditions)
  - [`#fail`](#fail)
- [Test Resources](#Test-Resources)
  - [File Resource](#File-Resource)
  - [Compressed File Resource](#Compressed-File-Resource)


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

A global `TestResource` namespace and members are provided for accessing test resources in a test target.

Recommended structure for using ``TestResource``:

1. Create a base `TestResource` folder in your package's test target.
2. Create subfolder(s) within the `TestResource` folder as desired in your package's testing target to contain the test resource files.

   For example, add the following to your `Package.swift`:
   ```swift
   .testTarget(
       // ...
       resources: [.copy("TestResource/TextFiles")]
   )
   ```

   > Note:
   >
   > In some cases, naming any of these folders `"Resources"` may cause build errors.
3. In the `TestResource` folder, create a `TestResource.swift` file where you will declare test resource files available in the target.

### File Resource

For each file within any subfolder(s) located with the `TestResource` folder, declare them individually as static properties.

For example, if a single subfolder named `"TextFiles"` contains two files `Foo.txt` and `Bar.csv` then these would be declared as follows:

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

For complex testing environments it may be desirable to organize file declarations into sub-namespaces under the `TestResource` extension. In that case, simply nest them under actors.

Note that each subfolder referenced would require an individual `resources` declaration in your `Package.swift`.

```swift
extension TestResource {
    enum TextFiles {
        static let subFolder = "TextFiles"
        
        static let foo = TestResource.File(
            name: "Foo", ext: "txt", subFolder: subFolder
        )
        // etc. ...
    }
    actor JSONFiles {
        static let subFolder = "JSONFiles"
        
        static let bar = TestResource.File(
            name: "Bar", ext: "json", subFolder: subFolder
        )
        // etc. ...
    }
}
```

#### Use In Testing

To utilize these files in automated unit tests, access them as follows:

Getting a URL to a test resource file:
```swift
let url = try #require(try TestResource.foo.url())
```

Directly reading a test resource file's contents:
```swift
let data = try #require(try TestResource.foo.data())
```

### Compressed File Resource

`TestResource` offers an optional feature to compress test resource files so that they occupy less storage space in the repository. For some file types this can result in dramatic space savings.

For each file within any subfolder(s) located with the `TestResource` folder that are to be treated as compressed files, declare them individually as static `CompressedFile` properties.

For example, if a single subfolder named `"TextFiles"` contains two compressed files `Foo.txt.lzfse` and `Bar.csv.lzfse` then these would be declared as follows:

```swift
extension TestResource {
    static let foo = TestResource.CompressedFile(
        name: "Foo", ext: "txt", subFolder: "TextFiles", compression: .lzfse
    )
    static let bar = TestResource.CompressedFile(
        name: "Bar", ext: "csv", subFolder: "TextFiles", compression: .lzfse
    )
}
```

Each file that is declared as `CompressedFile` must be compressed before adding to the repo.

These files can be compressed manually by running a temporary unit test case containing the following utility function:

```swift
@Test func temporaryFileCompressionUtility() throws {
    // ie: an uncompressed file named "Foo.txt" is located on the desktop
    let folder = URL.desktopDirectory
    try TestResource.foo.manuallyCompressFile(locatedIn: folder)
    // outputs "Foo.txt.lzfse" file to the desktop, ready to move into the package
}
```

The output file can then be moved into the package within the test target's `/TestResource/X/` subfolder (where `X` is an appropriate subfolder to contain the file).

> [!IMPORTANT]
> Ensure that this method is commented out or deleted after you are finished using it so that this operation is not called as part of your automated unit testing.

#### Use In Testing

To utilize these files in automated unit tests, the uncompressed file contents may be read directly with a single method call:

```swift
// uncompresses the file's contents and returns it as Data
let data = try #require(try TestResource.foo.data())
```

#### Manually Decompress Test Resource For Editing

At any time, a compressed resource file can be decompressed manually and written to an uncompressed file:

```swift
let folder = URL.desktopDirectory
try TestResource.foo.manuallyDecompress(intoFolder: folder)
// outputs "Foo.txt" file to the desktop
```

> [!IMPORTANT]
> Note that this method is not meant to be run as part of automated unit testing, but is provided as a utility when the file requires editing in order to be recompressed again and replaced in the package at a later time. For use in automated testing, call the `data()` method instead to return the uncompressed raw file content.

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

### Macro Trust

This package emits custom [Swift macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/).

Xcode includes a security mechanism that requires allowing 3rd-party macros before they are allowed to be used.

- When running in the Xcode IDE, a dialog will pop up asking to allow the macros.

  This will happen only once per commit of the repo where the macros originate. This means whenever the macros change or are updated, Xcode invalidates the previous authorization and re-prompts to allow them.

- When running CI unit tests using `xcodebuild test`, if the process errors out, the simplest solution currently is to add the `-skipMacroValidation` flag.

## Roadmap

- Additional methods may be added over time on an as-needed basis.

- Currently only Apple platforms are supported. However, since Swift Testing is a multiplatform package, additional platforms may be supported in future, including Linux and/or Windows.

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/swift-testing-extensions/blob/master/LICENSE) for details.

This package has no affiliation with the [Swift Testing](https://github.com/swiftlang/swift-testing) project but is offered as-is for use in conjunction with it.

## Contributions

Bug fixes and improvements are welcome. Please open an issue to discuss prior to submitting PRs.

