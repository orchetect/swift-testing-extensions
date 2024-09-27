//
//  Macro Implementations.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Returns the module bundle (`Module.bundle`) for the current scope.
/// Call using the `#moduleBundle` macro.
///
/// Implementing this as a Swift macro allows us to have methods in an external module
/// reference the calling module's bundle.
public struct ModuleBundleMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        "Bundle.module"
    }
}
