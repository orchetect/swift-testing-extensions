//
//  TestWithoutResourcesTests.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.URL
#else
import struct FoundationEssentials.URL
#endif

import Testing
import TestingExtensions
@testable import TestWithoutResources

@Test
func waitExpect() async {
    let value = true
    await wait(expect: { value }, timeout: 1.0)
}

@Test
func waitRequire() async throws {
    let value = true
    try await wait(require: { value }, timeout: 1.0)
}

@Test
func failMacro() {
    withKnownIssue {
        #fail()
    }

    withKnownIssue {
        #fail("Failure reason here.")
    }
}

/// `TestResource.File` may still be used with no resources present in the test target,
/// but only if we don't reference the `#moduleBundle` macro or directly reference `Bundle.module`.
///
/// Note that the `#moduleBundle` macro will not compile, because this test target does not have any
/// resources files defined. Without any resources, Swift does not synthesize `Bundle.module`.
@Test
func testResourceFile() {
    let file = TestResource.File(name: "Filename", ext: "txt", subFolder: nil)

    // this will not compile, as the bundle parameter is defaulted to `#moduleBundle`
    // let _ = try file.url(bundle: .main)

    // this will compile, because we are specifying the bundle parameter value, so its default is not evaluated
    withKnownIssue {
        // will trigger a failed expectation, as the file does not actually exist
        let _: URL = try file.url(bundle: .main)
    }
}
