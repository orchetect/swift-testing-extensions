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
///
///    For example, add the following to your `Package.swift`:
///    ```swift
///    .testTarget(
///        ...
///        resources: [.copy("TestResource/TextFiles")]
///    )
///    ```
///    > Important: DO NOT name any folders "Resources" otherwise Xcode may fail to build targets.
/// 3. In the `TestResource` folder, create a `TestResource.swift` file where you will declare
///    test resource files available in the target.
/// 4. For each file within any subfolder(s) located with the `TestResource` folder,
///    declare them individually as static properties.
///    For example, if a single subfolder named "TextFiles" contains two files `Foo.txt`
///    and `Bar.csv` then these would be declared as follows:
///
///    ```swift
///    extension TestResource {
///        static let foo = TestResource.File(
///            name: "Foo", ext: "txt", subFolder: "TextFiles"
///        )
///        static let bar = TestResource.File(
///            name: "Bar", ext: "csv", subFolder: "TextFiles"
///        )
///    }
///    ```
///
///    For complex testing environments it may be desirable to organize file declarations into
///    sub-namespaces under the `TestResource` extension. In that case, simply nest them under actors:
///
///    Note that each subfolder referenced would require an individual `resources` declaration in
///    your `Package.swift`.
///
///    ```swift
///    extension TestResource {
///        actor TextFiles {
///            static let subFolder = "TextFiles"
///
///            static let foo = TestResource.File(
///                name: "Foo", ext: "txt", subFolder: subFolder
///            )
///            // etc. ...
///        }
///        actor JSONFiles {
///            static let subFolder = "JSONFiles"
///
///            static let bar = TestResource.File(
///                name: "Bar", ext: "json", subFolder: subFolder
///            )
///            // etc. ...
///        }
///    }
///    ```
/// 5. To utilize these files in unit tests, access them as follows:
///    Getting a URL to a test resource file:
///    ```swift
///    let url = try #require(try TestResource.foo.url())
///    ```
///    Directly reading a test resource file's contents:
///    ```swift
///    let data = try #require(try TestResource.foo.data())
///    ```
public enum TestResource {
    // (consumer declares static constants in their target under this namespace)
}
