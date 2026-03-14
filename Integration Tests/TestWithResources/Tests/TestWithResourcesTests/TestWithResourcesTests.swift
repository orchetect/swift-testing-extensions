import Testing
@testable import TestWithResources
import TestingExtensions

@Test func waitExpect() async throws {
    let value = true
    await wait(expect: { value }, timeout: 1.0)
}

@Test func waitRequire() async throws {
    let value = true
    try await wait(require: { value }, timeout: 1.0)
}

@Test func failMacro() async throws {
    withKnownIssue {
        #fail()
    }
    
    withKnownIssue {
        #fail("Failure reason here.")
    }
}

/// Read the contents of a test target resource file using the `TestResource` API.
@Test func testResourceAccess() async throws {
    let data = try TestResource.foo.data()
    guard let string = String(data: data, encoding: .utf8) else {
        throw TestResourceError.stringDecodingFailed
    }
    #expect(string == "Foo file content")
}

/// Read the contents of a test target resource file manually using the `#moduleBundle` macro.
@Test func moduleBundleMacro() async throws {
    let bundle = #moduleBundle
    guard let url = bundle.url(forResource: "Foo", withExtension: "txt", subdirectory: "Text Files") else {
        throw TestResourceError.resourceURLNotFound
    }
    let data = try Data(contentsOf: url)
    guard let string = String(data: data, encoding: .utf8) else {
        throw TestResourceError.stringDecodingFailed
    }
    #expect(string == "Foo file content")
}

enum TestResourceError: Error {
    case resourceURLNotFound
    case stringDecodingFailed
    
    var localizedDescription: String {
        switch self {
        case .resourceURLNotFound: "URL for resource not found."
        case .stringDecodingFailed: "String decoding failed."
        }
    }
}
