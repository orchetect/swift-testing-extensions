//
//  Macro Implementations.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

// MARK: - Generic

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

// MARK: - Swift Testing Extensions

#if canImport(Testing)
import Testing

/// The `#fail` condition is an extension of Swift Testing and is analogous to XCTest's `XCTFail()`
/// method and can be used as a stand-in for its functionality.
///
/// This can be useful when standard Swift Testing conditions are not possible.
public struct FailMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        // Note:
        // - invoking `#expect` is a shortcut and not ideal, but it gets the job done.
        // - if it's possible to implement in a more idiomatic way, akin to how Swift Testing
        //   implements its macros, it could be internally refactored in future while retaining
        //   the same syntax.
        // - using `Bool()` silences the compiler warning that the expression always fails.
        var output = "#expect(Bool(false)"
        
        // first argument is `_ comment:` and has no label
        // so it seems the only criteria we can use to identify it
        // is the fact that it's the first argument and it lacks a label.
        // this is brittle and can break if the macro parameter signature changes
        // and contains more than one hidden label.
        // (there must be a better way to do this...)
        if let commentArg = node.arguments.first,
           commentArg.label == nil
        {
            let comment = commentArg.expression
            output += ", \(comment)"
        }
        
        if let sourceLocation = node.arguments.first(labeled: "sourceLocation")?
            .expression
        {
            output += ", sourceLocation: \(sourceLocation)"
        }
        
        output += ")"
        
        return ExprSyntax(stringLiteral: output)
    }
}

#endif
