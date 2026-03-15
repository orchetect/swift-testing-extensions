//
//  Algorithm+LZMA.swift
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
    /// The LZMA compression algorithm, recommended for high-compression ratio.
    ///
    /// Use this algorithm if compression ratio is critical, and you’re willing to sacrifice speed to achieve it.
    /// It is an order of magnitude slower for both compression and decompression than other choices.
    public struct LZMACompressionAlgorithm {
        public init() { }
    }
}

extension TestResource.CompressedFile.LZMACompressionAlgorithm: Equatable { }

extension TestResource.CompressedFile.LZMACompressionAlgorithm: Hashable { }

extension TestResource.CompressedFile.LZMACompressionAlgorithm: Sendable { }

extension TestResource.CompressedFile.LZMACompressionAlgorithm: TestResource.CompressedFile.Algorithm {
    public var fileExtension: String {
        "lzma"
    }

    public func compress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression
        try data.compressed(using: .lzma)
        #else
        // TODO: not yet supported by SWCompression
        throw TestResourceError.notSupported
        #endif
    }

    public func decompress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression
        try data.decompressed(using: .lzma)
        #else
        // use 3rd-party SWCompression dependency provided method
        try LZMA.decompress(data: data)
        #endif
    }
}

// MARK: - Static Constructors

extension TestResource.CompressedFile.Algorithm where Self == TestResource.CompressedFile.LZMACompressionAlgorithm {
    /// The LZMA compression algorithm, recommended for high-compression ratio.
    ///
    /// Use this algorithm if compression ratio is critical, and you’re willing to sacrifice speed to achieve it.
    /// It is an order of magnitude slower for both compression and decompression than other choices.
    public static var lzma: TestResource.CompressedFile.LZMACompressionAlgorithm {
        TestResource.CompressedFile.LZMACompressionAlgorithm()
    }
}
