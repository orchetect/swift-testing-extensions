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
    
    static let bar = TestResource.CompressedFile(
        name: "Bar", ext: "txt", subFolder: "ResourceFiles", compression: .lzfse
    )
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) // URL path() requirement
@Test func testResourceURL() async throws {
    let url = try TestResource.foo.url()
    #expect(FileManager.default.fileExists(atPath: url.path(percentEncoded: false)))
}

@Test func testResourceData() async throws {
    let data = try TestResource.foo.data()
    let string = try #require(String(data: data, encoding: .utf8))
    #expect(string == "Foo file content")
}

@available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) // URL path() requirement
@Test func compressedTestResourceURL() async throws {
    let url = try TestResource.bar.url()
    #expect(FileManager.default.fileExists(atPath: url.path(percentEncoded: false)))
}

@Test func compressedTestResourceData() async throws {
    let data = try TestResource.bar.data()
    let string = try #require(String(data: data, encoding: .utf8))
    #expect(string == "Bar file content")
}

@Test(.enabledIfShiftOnlyIsDown)
func manualCompressionUtility() async throws {
    // try TestResource.bar.manuallyCompressFile(locatedIn: .desktopDirectory)
    // try TestResource.bar.manuallyDecompress(intoFolder: .desktopDirectory)
}
