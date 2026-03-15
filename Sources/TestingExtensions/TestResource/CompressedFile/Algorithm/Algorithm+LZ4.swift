//
//  Algorithm+LZ4.swift
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
    /// The LZ4 compression algorithm, recommended for fast compression.
    ///
    /// Use this algorithm if speed is critical, and you’re willing to sacrifice compression ratio to achieve it.
    public struct LZ4CompressionAlgorithm {
        public init() { }
    }
}

extension TestResource.CompressedFile.LZ4CompressionAlgorithm: Equatable { }

extension TestResource.CompressedFile.LZ4CompressionAlgorithm: Hashable { }

extension TestResource.CompressedFile.LZ4CompressionAlgorithm: Sendable { }

extension TestResource.CompressedFile.LZ4CompressionAlgorithm: TestResource.CompressedFile.Algorithm {
    public var fileExtension: String {
        "lz4"
    }

    public func compress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression
        try data.compressed(using: .lz4)
        #else
        // use 3rd-party SWCompression dependency provided method
        
        // note that Apple's LZ4 (not LZ4 RAW) adds an 8-byte header and a 4-byte footer.
        // SWCompression does not add them when compressing, nor does it expect them when decoding.
        // So we should add them after encoding using SWCompression.
        // See: https://developer.apple.com/documentation/compression/compression_lz4
        // TODO: add header and footer bytes
        LZ4.compress(data: self)
        #endif
    }

    public func decompress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression
        try data.decompressed(using: .lz4)
        #else
        // use 3rd-party SWCompression dependency provided method
        
        // note that Apple's LZ4 (not LZ4 RAW) adds an 8-byte header and a 4-byte footer.
        // SWCompression does not add them when compressing, nor does it expect them when decoding.
        // So we should trim them off before decoding using SWCompression.
        // See: https://developer.apple.com/documentation/compression/compression_lz4
        // TODO: strip header and footer bytes
        try LZ4.decompress(data: self)
        #endif
    }
}

// MARK: - Static Constructors

extension TestResource.CompressedFile.Algorithm where Self == TestResource.CompressedFile.LZ4CompressionAlgorithm {
    /// The LZ4 compression algorithm, recommended for fast compression.
    ///
    /// Use this algorithm if speed is critical, and you’re willing to sacrifice compression ratio to achieve it.
    public static var lz4: TestResource.CompressedFile.LZ4CompressionAlgorithm {
        TestResource.CompressedFile.LZ4CompressionAlgorithm()
    }
}
