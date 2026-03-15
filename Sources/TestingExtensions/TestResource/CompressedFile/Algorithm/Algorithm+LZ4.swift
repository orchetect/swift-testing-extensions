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
        
        // note that Apple's LZ4 (not LZ4 RAW) adds a block header (which has two variants) and a 4-byte footer.
        // SWCompression does not add them when compressing, nor does it expect them when decoding.
        // So we should add them after encoding using SWCompression.
        // See: https://developer.apple.com/documentation/compression/compression_lz4
        
        // TODO: add header and footer bytes that Apple's lz4 algorithm would add
        
        LZ4.compress(data: data)
        #endif
    }

    public func decompress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression
        try data.decompressed(using: .lz4)
        #else
        // use 3rd-party SWCompression dependency provided method
        
        // note that Apple's LZ4 (not LZ4 RAW) adds a block header (which has two variants) and a 4-byte footer.
        // SWCompression does not add them when compressing, nor does it expect them when decoding.
        // So we should trim them off before decoding using SWCompression.
        // See: https://developer.apple.com/documentation/compression/compression_lz4
        
        // the block header is either compressed or uncompressed.
        // - A compressed block header consists of the octets 0x62, 0x76, 0x34, and 0x31.
        //   Following that is the size (in bytes) of the decoded (plaintext) data the block represents,
        //   and the size (in bytes) of the encoded data stored in the block. The header stores both sizes
        //   as (potentially unaligned) 32-bit little-endian values. The actual LZ4-encoded data stream immediately
        //   follows the compressed block header.
        // - An uncompressed block header consists of the octets 0x62, 0x76, 0x34, and 0x2d.
        //   Following that is a single 32-bit little-endian value representing the plaintext data’s size (in bytes),
        //   and then the plaintext data itself.
        
        let compressedHeaderPreamble: [UInt8] = [0x62, 0x76, 0x34, 0x31]
        let expectedCompressedHeaderByteCount: Int = 4 + 4 + 4
        
        let uncompressedHeaderPreamble: [UInt8] = [0x62, 0x76, 0x34, 0x2D]
        let expectedUncompressedHeaderByteCount: Int = 4 + 4
        
        let headerByteCount: Int = if data.starts(with: compressedHeaderPreamble), data.count >= expectedCompressedHeaderByteCount {
            expectedCompressedHeaderByteCount
        } else if data.starts(with: uncompressedHeaderPreamble), data.count >= expectedUncompressedHeaderByteCount {
            expectedUncompressedHeaderByteCount
        } else {
            throw TestResourceError.invalidDataHeader
        }
        
        // the block footer consists of the octets 0x62, 0x76, 0x34, and 0x24 and identifies the end of the LZ4 frame
        
        let footer: [UInt8] = [0x62, 0x76, 0x34, 0x24]
        let footerByteCount: Int = 4
        guard data.suffix(4) == footer else {
            throw TestResourceError.invalidDataFooter
        }
        
        // discard header and footer bytes.
        // (we could use the header data to check overall data integrity first, but we're skipping that step because we're lazy.)
        // no need to do data length check, as the header and footer checks guarantee forming this range won't crash
        let dataSlice = data[
            data.startIndex.advanced(by: headerByteCount) ..< data.endIndex.advanced(by: -footerByteCount)
        ]
        
        return try LZ4.decompress(data: dataSlice)
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
