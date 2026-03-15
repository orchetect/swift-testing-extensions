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
import class Foundation.Bundle
import struct FoundationEssentials.Data
import class FoundationEssentials.FileManager
#endif

import Testing
@testable import TestingExtensions

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
    
    @Test func compressedTestResourceData_lz4_uncompressedBlock() async throws {
        let data = try TestResource.bar(.lz4).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
    
    @Test func compressedTestResourceData_lz4_compressedBlock() async throws {
        // 240 bytes total, comprised of the 15-byte sequence `0x01...0x0F` repeated 16 times
        let expectedBytes: [UInt8] = (0 ..< 16)
            .reduce(into: []) { base, _ in
                base.append(contentsOf: Array(UInt8(0x01)...UInt8(0x0F)))
            }
        #expect(expectedBytes.count == 240)
        
        let data = try TestResource.baz.data()
        #expect(data == Data(expectedBytes))
    }
    
    #if canImport(Darwin) // lzfse is not yet supported on non-Apple platforms
    @Test func compressedTestResourceData_lzfse() async throws {
        let data = try TestResource.bar(.lzfse).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
    #endif
    
    @Test func compressedTestResourceData_lzma() async throws {
        let data = try TestResource.bar(.lzma).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
}
