//
//  Conditions Tests.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Testing
/* @testable */ import TestingExtensions

@Test func failThrows() async throws {
    // using withKnownIssue is a simple way to test if this works as expected
    withKnownIssue {
        fail("This closure should fail")
    }
}
