//
//  TestResource.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Testing

/// Namespace for resources files on disk used for unit testing.
///
/// Recommended structure for using ``TestResource``:
///
/// 1. Create a base `TestResource` folder in your package's test target.
/// 2. Create subfolder(s) within the `TestResource` folder as desired in your package's
///    testing target to contain the test resource files.
///    For example, if a folder named "Add the following to your `Package.swift`:
///    ```swift
///    .testTarget(
///        ...
///        resources: [.copy("TestResource/SomeFolder")]
///    )
///    ```
///    > Important: DO NOT name any folders "Resources" otherwise Xcode may fail to build targets.
/// 3. In the `TestResource` folder, create a `TestResource.swift` file where you will declare
///    test resource files available in the target.
/// 4. For each file within any subfolder(s) located with the `TestResource` folder,
///    declare them individually as static properties.
///    - For example, if a single subfolder named "Text" contains two files `Foo.txt` and `Bar.csv`
///      then these would be declared as follows:
///
///      ```swift
///      extension TestResource {
///          static let foo = TestResource.File(
///              name: "Foo", ext: "txt", subFolder: "TextFiles"
///          )
///          static let bar = TestResource.File(
///              name: "Bar", ext: "csv", subFolder: "TextFiles"
///          )
///      }
///      ```
/// 5. To utilize these files in unit tests, access them as follows:
///    Getting a URL to a test resource file:
///    ```swift
///    let url = try #require(try TestResource.foo.url())
///    ```
///    Directly reading a test resource file's contents:
///    ```swift
///    let data = try #require(try TestResource.foo.data())
///    ```
@globalActor public actor TestResource {
    public static let shared = TestResource()
    
    // (consumer declares static constants in their target under this namespace)
}

// MARK: - TestResource File

extension TestResource {
    /// Metadata describing a test resource file that exists in the test target.
    public class File {
        public let name: String
        public let ext: String?
        public let subFolder: String?
        
        public init(name: String, ext: String? = nil, subFolder: String? = nil) {
            self.name = name
            self.ext = ext
            self.subFolder = subFolder
        }
        
        /// Returns the file URL for the resource file or `nil` if the file could not be located.
        /// This method also returns `nil` if the bundle does not exist is not a readable directory.
        @inline(__always)
        public func url(
            bundle: Bundle = #moduleBundle,
            sourceLocation: SourceLocation = #_sourceLocation
        ) throws -> URL {
            // Note: Bundle.module is synthesized when the package target has `resources: [...]`
            try #require(
                bundle.url(
                    forResource: self.name,
                    withExtension: self.ext,
                    subdirectory: self.subFolder
                ),
                "Test resource file not found or is not accessible.",
                sourceLocation: #_sourceLocation
            )
        }
        
        /// Returns the contents of the test resource file or `nil` if the file could not be located.
        /// This method also returns `nil` if the bundle does not exist is not a readable directory.
        @inline(__always)
        public func data(
            bundle: Bundle = #moduleBundle,
            sourceLocation: SourceLocation = #_sourceLocation
        ) throws -> Data {
            let fileURL = try #require(
                try url(bundle: bundle, sourceLocation: sourceLocation),
                "Test resource file not found or is not accessible.",
                sourceLocation: sourceLocation
            )
            let data = try #require(
                try Data(contentsOf: fileURL),
                "Could not read file contents of test resource file.",
                sourceLocation: sourceLocation
            )
            return data
        }
    }
}

extension TestResource.File: Equatable {
    public static func == (lhs: TestResource.File, rhs: TestResource.File) -> Bool {
        lhs.name == rhs.name &&
            lhs.ext == rhs.ext &&
            lhs.subFolder == rhs.subFolder
    }
}

extension TestResource.File: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(ext)
        hasher.combine(subFolder)
    }
}

// MARK: - Public Members

extension TestResource.File {
    /// Returns the full filename including extension, if any.
    @inline(__always)
    public var fileName: String {
        var fn = name
        if let ext { fn += ".\(ext)" }
        return fn
    }
}
