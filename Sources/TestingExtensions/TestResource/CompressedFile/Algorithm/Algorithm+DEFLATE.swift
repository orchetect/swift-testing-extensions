//
//  Algorithm+DEFLATE.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
import struct Foundation.Data
#else
import struct FoundationEssentials.Data
import SWCompression
#endif

extension TestResource.CompressedFile {
    /// The DEFLATE compression algorithm (used by `zlib`), recommended for cross-platform compression.
    /// This compresses and decompresses using the raw DEFLATE algorithm.
    ///
    /// Use this algorithm if your app requires interoperability with non-Apple devices.
    /// For example, if you are transferring data to another device where it needs to be compressed or decompressed.
    public struct DeflateCompressionAlgorithm {
        public init() { }
    }
}

extension TestResource.CompressedFile.DeflateCompressionAlgorithm: Equatable { }

extension TestResource.CompressedFile.DeflateCompressionAlgorithm: Hashable { }

extension TestResource.CompressedFile.DeflateCompressionAlgorithm: Sendable { }

extension TestResource.CompressedFile.DeflateCompressionAlgorithm: TestResource.CompressedFile.Algorithm {
    public var fileExtension: String {
        "deflate"
    }
    
    public func compress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // Apple's NSData-provided zlib algorithm is actually just raw DEFLATE, which is used by zlib archives
        try data.compressed(using: .zlib)
        #else
        // use 3rd-party SWCompression dependency provided method
        Deflate.compress(data: data)
        #endif
    }
    
    public func decompress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // Apple's NSData-provided zlib algorithm is actually just raw DEFLATE, which is used by zlib archives
        try data.decompressed(using: .zlib)
        #else
        // use 3rd-party SWCompression dependency provided method
        try Deflate.decompress(data: data)
        #endif
    }
}

// MARK: - Static Constructors

extension TestResource.CompressedFile.Algorithm where Self == TestResource.CompressedFile.DeflateCompressionAlgorithm {
    /// The DEFLATE compression algorithm (used by `zlib`), recommended for cross-platform compression.
    /// This compresses and decompresses using the raw DEFLATE algorithm.
    ///
    /// Use this algorithm if your app requires interoperability with non-Apple devices.
    /// For example, if you are transferring data to another device where it needs to be compressed or decompressed.
    public static var deflate: TestResource.CompressedFile.DeflateCompressionAlgorithm {
        TestResource.CompressedFile.DeflateCompressionAlgorithm()
    }
}
