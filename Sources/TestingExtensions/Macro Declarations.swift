//
//  Macro Declarations.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Returns the module bundle (`Module.bundle`) for the current scope.
///
/// Implementing this as a Swift macro allows us to have methods in an external module
/// reference the calling module's bundle.
@freestanding(expression)
public macro moduleBundle() -> Bundle =
    #externalMacro(module: "TestingExtensionsMacros", type: "ModuleBundleMacro")
