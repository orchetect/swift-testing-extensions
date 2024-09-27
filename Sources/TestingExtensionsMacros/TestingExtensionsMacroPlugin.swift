//
//  TestingExtensionsMacroPlugin.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct TestingExtensionsMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ModuleBundleMacro.self
    ]
}
