//
//  TestResource File Tests.swift
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

@Suite struct TestResource_File_Tests_foo {
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

@Suite struct TestResource_File_Tests_bar {
    @Test func resourceData() async throws {
        let data = try TestResource.bar.data()
        let string = try #require(String(data: data, encoding: .utf8))
        #expect(string == "Bar file content")
    }
}

@Suite struct TestResource_File_Tests_baz {
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
}
