//
//  Macro Tests.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

import Testing
/* @testable */ import TestingExtensions

@Test func failMacro() async throws {
    withKnownIssue {
        #fail
    }
    
    withKnownIssue {
        #fail("Failure reason.")
    }
}

// MARK: - Macro Implementation Testing

import XCTest
import TestingExtensionsMacros

/// > Note:
/// > - At the time this code was written, `assertMacroExpansion` only asserts
/// >   with XCTest tests and has no effect when using Swift Testing.
/// > - If `SwiftSyntaxMacrosTestSupport` is updating in future to add Swift Testing support,
/// >   this can be refactored to use it.
final class AssertTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "fail": FailMacro.self
    ]

    func testFailMacroExpansion() {
        #if canImport(TestingExtensionsMacros)
        assertMacroExpansion(
            """
            #fail
            """,
            expandedSource: """
            #expect(Bool(false))
            """,
            macros: testMacros
        )
        
        assertMacroExpansion(
            """
            #fail("Failure reason.")
            """,
            expandedSource: """
            #expect(Bool(false), "Failure reason.")
            """,
            macros: testMacros
        )
        
        assertMacroExpansion(
            """
            #fail("Failure reason.", sourceLocation: SourceLocation(fileID: "id", filePath: "path", line: 20, column: 4))
            """,
            expandedSource: """
            #expect(Bool(false), "Failure reason.", sourceLocation: SourceLocation(fileID: "id", filePath: "path", line: 20, column: 4))
            """,
            macros: testMacros
        )
        
        assertMacroExpansion(
            """
            #fail(sourceLocation: SourceLocation())
            """,
            expandedSource: """
            #expect(Bool(false), sourceLocation: SourceLocation())
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("Macros unavailable for testing.")
        #endif
    }
}