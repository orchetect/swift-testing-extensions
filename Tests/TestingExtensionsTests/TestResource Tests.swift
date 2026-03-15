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

@Suite struct TestResource_Tests_foo {
    @Test func resourceData() async throws {
        let data = try TestResource.foo.data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Foo file content")
    }
    
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *) // URL path() requirement
    @Test func resourceURL() async throws {
        let url = try TestResource.foo.url()
        #expect(FileManager.default.fileExists(atPath: url.path(percentEncoded: false)))
    }
}

@Suite struct TestResource_Tests_bar {
    @Test func resourceData() async throws {
        let data = try TestResource.bar.data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
    
    @Test func compressedResourceData_deflate() async throws {
        let data = try TestResource.bar(.deflate).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
    
    /// Note that this file's data contains an **uncompressed** LZ4 data block, as determined by the algorithm
    #if canImport(Darwin) // lz4 is not yet supported on non-Apple platforms
    @Test func compressedResourceData_lz4() async throws {
        let data = try TestResource.bar(.lz4).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
    #endif
    
    #if canImport(Darwin) // lzfse is not yet supported on non-Apple platforms
    /// Note that this file's data contains an **uncompressed** LZFSE data block, as determined by the algorithm
    @Test func compressedResourceData_lzfse() async throws {
        let data = try TestResource.bar(.lzfse).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
    #endif
    
    /// Note that this file's data contains an **uncompressed** LZMA2 data block, as determined by the algorithm
    @Test func compressedResourceData_lzma2xz() async throws {
        let data = try TestResource.bar(.lzma2xz).data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
}

@Suite struct TestResource_baz {
    /// Uncompressed Baz.bin file content:
    /// 240 bytes total, comprised of the 15-byte sequence `0x01...0x0F` repeated 16 times.
    private let expectedBytes: [UInt8] = (0 ..< 16)
        .reduce(into: []) { base, _ in
            base.append(contentsOf: Array(UInt8(0x01)...UInt8(0x0F)))
        }
    private lazy var expectedData = Data(expectedBytes)
    
    init() {
        // sanity check
        #expect(expectedBytes.count == 240)
    }
    
    @Test mutating func resourceData() async throws {
        let data = try TestResource.baz.data()
        #expect(data == expectedData)
    }
    
    @Test mutating func compressedResourceData_deflate() async throws {
        let data = try TestResource.baz(.deflate).data()
        #expect(data == expectedData)
    }
    
    #if canImport(Darwin) // lz4 is not yet supported on non-Apple platforms
    /// Note that this file's data contains a **compressed** LZ4 data block, as determined by the algorithm
    @Test mutating func compressedResourceData_lz4() async throws {
        let data = try TestResource.baz(.lz4).data()
        #expect(data == expectedData)
    }
    #endif
    
    #if canImport(Darwin) // lzfse is not yet supported on non-Apple platforms
    /// Note that this file's data contains a **compressed** LZFSE data block, as determined by the algorithm
    @Test mutating func compressedResourceData_lzfse() async throws {
        let data = try TestResource.baz(.lzfse).data()
        #expect(data == expectedData)
    }
    #endif
    
    /// Note that this file's data contains a **compressed** LZMA2 data block, as determined by the algorithm
    @Test mutating func compressedResourceData_lzma2xz() async throws {
        let data = try TestResource.baz(.lzma2xz).data()
        #expect(data == expectedData)
    }
}
