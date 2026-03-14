//
//  TestResource Tests.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import class Foundation.Bundle
import struct Foundation.Data
import class Foundation.FileManager
#else
import class FoundationEssentials.Bundle
import struct FoundationEssentials.Data
import class FoundationEssentials.FileManager
#endif

import Testing
@testable import TestingExtensions

extension TestResource {
    static let foo = TestResource.File(
        name: "Foo", ext: "txt", subFolder: "ResourceFiles"
    )
    
    /// This file on disk is available in compressed form using all of the available algorithms.
    static func bar(_ algorithm: CompressionAlgorithm) -> TestResource.CompressedFile {
        TestResource.CompressedFile(
            name: "Bar", ext: "txt", subFolder: "ResourceFiles", compression: algorithm
        )
    }
}

@Suite struct TestResource_Tests {
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
        let url = try TestResource.bar(.deflate).url()
        #expect(FileManager.default.fileExists(atPath: url.path(percentEncoded: false)))
    }
}

@Suite struct TestResource_Decompress_Tests {
    @Test func compressedTestResourceData_deflate() async throws {
        let data = try TestResource.bar(.deflate).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
    
    @Test func compressedTestResourceData_lz4() async throws {
        let data = try TestResource.bar(.lz4).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
    
    @Test func compressedTestResourceData_lzfse() async throws {
        #if canImport(Darwin)
        let data = try TestResource.bar(.lzfse).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
        #else
        withKnownIssue("lzfse compression algorithm is not yet support on non-Apple platforms.") {
            _ = try TestResource.bar(.lzfse).data()
        }
        #endif
    }

    @Test func compressedTestResourceData_lzma() async throws {
        let data = try TestResource.bar(.lzma).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
}
