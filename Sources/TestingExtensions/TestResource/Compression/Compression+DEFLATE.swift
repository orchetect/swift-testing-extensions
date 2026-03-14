//
//  Compression+DEFLATE.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
#else
import struct FoundationEssentials.Data
import SWCompression
#endif

extension TestResource {
    /// The DEFLATE compression algorithm (used by `zlib`), recommended for cross-platform compression.
    /// This compresses and decompresses using the raw DEFLATE algorithm.
    ///
    /// Use this algorithm if your app requires interoperability with non-Apple devices.
    /// For example, if you are transferring data to another device where it needs to be compressed or decompressed.
    public struct DeflateCompression {
        public init() { }
    }
}

extension TestResource.DeflateCompression: Equatable { }

extension TestResource.DeflateCompression: Hashable { }

extension TestResource.DeflateCompression: Sendable { }

extension TestResource.DeflateCompression: TestResource.Compression {
    public var fileExtension: String {
        "deflate"
    }
    
    public func compress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // Apple's zlib algorithm is actually just raw DEFLATE, which is used by zlib archives
        try data.compressed(using: .zlib)
        #else
        // use 3rd-party SWCompression dependency provided method
        Deflate.compress(data: self)
        #endif
    }
    
    public func decompress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // Apple's zlib algorithm is actually just raw DEFLATE, which is used by zlib archives
        try data.decompressed(using: .zlib)
        #else
        // use 3rd-party SWCompression dependency provided method
        try Deflate.decompress(data: self)
        #endif
    }
}

// MARK: - Static Constructors

extension TestResource.Compression where Self == TestResource.DeflateCompression {
    /// The DEFLATE compression algorithm (used by `zlib`), recommended for cross-platform compression.
    /// This compresses and decompresses using the raw DEFLATE algorithm.
    ///
    /// Use this algorithm if your app requires interoperability with non-Apple devices.
    /// For example, if you are transferring data to another device where it needs to be compressed or decompressed.
    public static var deflate: TestResource.DeflateCompression {
        TestResource.DeflateCompression()
    }
}
