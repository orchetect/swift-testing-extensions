//
//  Conditions.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

import Testing

/// Imperatively fail a test with an optional comment.
/// Swift Testing analogue to XCTest's `XCTFail`.
///
/// This can be useful when standard Swift Testing conditions are not possible:
///
/// ```swift
/// enum Foo {
///     case bar(String)
/// }
///
/// @Test func fooTest() async throws {
///     let foo = Foo.bar("foo")
///
///     guard case let .bar(string) = foo else {
///         fail()
///         return
///     }
/// }
/// ```
public func fail(
    _ comment: @autoclosure () -> Comment? = nil,
    sourceLocation: SourceLocation = #_sourceLocation
) {
    #expect(Bool(false), comment(), sourceLocation: sourceLocation)
}

#endif
