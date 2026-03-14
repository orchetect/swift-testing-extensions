//
//  Compression+LZ4.swift
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
    /// The LZ4 compression algorithm, recommended for fast compression.
    ///
    /// Use this algorithm if speed is critical, and you’re willing to sacrifice compression ratio to achieve it.
    public struct LZ4Compression {
        public init() { }
    }
}

extension TestResource.LZ4Compression: Equatable { }

extension TestResource.LZ4Compression: Hashable { }

extension TestResource.LZ4Compression: Sendable { }

extension TestResource.LZ4Compression: TestResource.Compression {
    public var fileExtension: String {
        "lz4"
    }

    public func compress(data: Data) throws -> Data {
        #if canImport(Darwin)
        try data.compressed(using: .lz4)
        #else
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
        try data.decompressed(using: .lz4)
        #else
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

extension TestResource.Compression where Self == TestResource.LZ4Compression {
    /// The LZ4 compression algorithm, recommended for fast compression.
    ///
    /// Use this algorithm if speed is critical, and you’re willing to sacrifice compression ratio to achieve it.
    public static var lz4: TestResource.LZ4Compression {
        TestResource.LZ4Compression()
    }
}
