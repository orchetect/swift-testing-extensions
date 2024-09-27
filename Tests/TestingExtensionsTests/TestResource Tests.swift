//
//  TestResource Tests.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Testing
@testable import TestingExtensions

extension TestResource {
    static let foo = TestResource.File(
        name: "Foo", ext: "txt", subFolder: "ResourceFiles"
    )
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) // URL path() requirement
@Test func testResourceURL() async throws {
    let url = try #require(try TestResource.foo.url())
    #expect(FileManager.default.fileExists(atPath: url.path()))
}

@Test func testResourceData() async throws {
    let data = try #require(try TestResource.foo.data())
    let string = try #require(String(data: data, encoding: .utf8))
    #expect(string == "Foo file content")
}
