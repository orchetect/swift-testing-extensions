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
@testable import TestingExtensions

@Test func failMacro() async throws {
    withKnownIssue {
        #fail
    }
    
    withKnownIssue {
        #fail("Failure reason.")
    }
}

// MARK: - Macro Implementation Testing

#if canImport(TestingExtensionsMacros)

import XCTest
@testable import TestingExtensionsMacros

/// > Note:
/// > - At the time this code was written, `assertMacroExpansion` only asserts
/// >   with XCTest tests and has no effect when using Swift Testing.
/// > - If `SwiftSyntaxMacrosTestSupport` is updating in future to add Swift Testing support,
/// >   this can be refactored to use it.
final class AssertTests: XCTestCase {
    let testMacros: [String: Macro.Type] = [
        "fail": FailMacro.self,
        "alternativeFail": AlternativeFailMacro.self
    ]
    
    func testFailMacroExpansion() {
        assertMacroExpansion(
            """
            #fail
            """,
            expandedSource: """
            _ = Issue.record()
            """,
            macros: testMacros
        )
        
        assertMacroExpansion(
            """
            #fail("Failure reason.")
            """,
            expandedSource: """
            _ = Issue.record("Failure reason.")
            """,
            macros: testMacros
        )
        
        assertMacroExpansion(
            """
            #fail("Failure reason.", sourceLocation: SourceLocation(fileID: "id", filePath: "path", line: 20, column: 4))
            """,
            expandedSource: """
            _ = Issue.record("Failure reason.", sourceLocation: SourceLocation(fileID: "id", filePath: "path", line: 20, column: 4))
            """,
            macros: testMacros
        )
        
        assertMacroExpansion(
            """
            #fail(sourceLocation: SourceLocation())
            """,
            expandedSource: """
            _ = Issue.record(sourceLocation: SourceLocation())
            """,
            macros: testMacros
        )
    }

    func testAlternativeFailMacroExpansion() {
        assertMacroExpansion(
             """
             #alternativeFail
             """,
             expandedSource: """
             #expect(Bool(false))
             """,
             macros: testMacros
        )
        
        assertMacroExpansion(
             """
             #alternativeFail("Failure reason.")
             """,
             expandedSource: """
             #expect(Bool(false), "Failure reason.")
             """,
             macros: testMacros
        )
        
        assertMacroExpansion(
             """
             #alternativeFail("Failure reason.", sourceLocation: SourceLocation(fileID: "id", filePath: "path", line: 20, column: 4))
             """,
             expandedSource: """
             #expect(Bool(false), "Failure reason.", sourceLocation: SourceLocation(fileID: "id", filePath: "path", line: 20, column: 4))
             """,
             macros: testMacros
        )
        
        assertMacroExpansion(
             """
             #alternativeFail(sourceLocation: SourceLocation())
             """,
             expandedSource: """
             #expect(Bool(false), sourceLocation: SourceLocation())
             """,
             macros: testMacros
        )
    }
}

#endif
