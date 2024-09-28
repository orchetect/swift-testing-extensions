//
//  Macro Declarations.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - Generic

/// Returns the module bundle (`Module.bundle`) for the current scope.
///
/// Implementing this as a Swift macro allows us to have methods in an external module
/// reference the calling module's bundle.
@freestanding(expression)
public macro moduleBundle() -> Bundle =
    #externalMacro(module: "TestingExtensionsMacros", type: "ModuleBundleMacro")

// MARK: - Swift Testing Extensions

#if canImport(Testing)
import Testing


/// The `#fail` condition is an extension of Swift Testing and is analogous to XCTest's `XCTFail()`
/// method and can be used as a stand-in for its functionality.
///
/// This can be useful when standard Swift Testing conditions are not possible.
@freestanding(expression)
public macro fail(
    _ comment: @autoclosure () -> Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) -> Void =
    #externalMacro(module: "TestingExtensionsMacros", type: "FailMacro")

#endif
