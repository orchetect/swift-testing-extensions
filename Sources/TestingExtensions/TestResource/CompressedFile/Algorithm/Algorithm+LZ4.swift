//
//  Algorithm+LZ4.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

#if canImport(Darwin)
import struct Foundation.Data
#else
import struct FoundationEssentials.Data

#endif

#if os(Linux)
// import SWCompression
// import SwiftDataParsing
#endif

extension TestResource.CompressedFile {
    /// The LZ4 compression algorithm, recommended for fast compression.
    ///
    /// Use this algorithm if speed is critical, and you’re willing to sacrifice compression ratio to achieve it.
    #if !canImport(Darwin)
    @available(*, unavailable, message: "Not yet available on this platform.")
    #endif
    public struct LZ4CompressionAlgorithm {
        public init() { }
    }
}

#if !canImport(Darwin)
@available(*, unavailable, message: "Not yet available on this platform.")
#endif
extension TestResource.CompressedFile.LZ4CompressionAlgorithm: Equatable { }

#if !canImport(Darwin)
@available(*, unavailable, message: "Not yet available on this platform.")
#endif
extension TestResource.CompressedFile.LZ4CompressionAlgorithm: Hashable { }

#if !canImport(Darwin)
@available(*, unavailable, message: "Not yet available on this platform.")
#endif
extension TestResource.CompressedFile.LZ4CompressionAlgorithm: Sendable { }

#if !canImport(Darwin)
@available(*, unavailable, message: "Not yet available on this platform.")
#endif
extension TestResource.CompressedFile.LZ4CompressionAlgorithm: TestResource.CompressedFile.Algorithm {
    public var fileExtension: String {
        "lz4"
    }

    public func compress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression
        try data.compressed(using: .lz4)
        #elseif os(Linux)
        // note that Apple's LZ4 (not LZ4 RAW) adds a block header (which has two variants) and a 4-byte footer.
        // SWCompression does not add them when compressing, nor does it expect them when decoding.
        // So we should add them after encoding using SWCompression.
        // See: https://developer.apple.com/documentation/compression/compression_lz4
        
        // after extensive research and trial-and-error, there wasn't a simple way to repack Apple's LZ4 compression format
        // to a format that was compatible with SWCompression
        //     LZ4.compress(data: data)
        
        throw TestResourceError.notSupported
        #else
        throw TestResourceError.notSupported
        #endif
    }

    public func decompress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression
        try data.decompressed(using: .lz4)
        #elseif os(Linux)
//        // use 3rd-party SWCompression dependency provided method
//        
//        // note that Apple's LZ4 (not LZ4 RAW) adds a block header (which has two variants) and a 4-byte footer.
//        // SWCompression does not add them when compressing, nor does it expect them when decoding.
//        // So we should trim them off before decoding using SWCompression.
//        // See: https://developer.apple.com/documentation/compression/compression_lz4
//        
//        // the block header is either compressed or uncompressed.
//        // - A compressed block header consists of the octets 0x62, 0x76, 0x34, and 0x31.
//        //   Following that is the size (in bytes) of the decoded (plaintext) data the block represents,
//        //   and the size (in bytes) of the encoded data stored in the block. The header stores both sizes
//        //   as (potentially unaligned) 32-bit little-endian values. The actual LZ4-encoded data stream immediately
//        //   follows the compressed block header.
//        // - An uncompressed block header consists of the octets 0x62, 0x76, 0x34, and 0x2d.
//        //   Following that is a single 32-bit little-endian value representing the plaintext data’s size (in bytes),
//        //   and then the plaintext data itself.
//        let compressedHeader: [UInt8] = [0x62, 0x76, 0x34, 0x31]
//        let uncompressedHeader: [UInt8] = [0x62, 0x76, 0x34, 0x2D]
//        
//        // the block footer consists of the octets 0x62, 0x76, 0x34, and 0x24 and identifies the end of the LZ4 frame
//        let footer: [UInt8] = [0x62, 0x76, 0x34, 0x24]
//        
//        // decode block
//        
//        return try data.withDataParser { parser in
//            let header = try parser.read(bytes: 4)
//            
//            if header == compressedHeader {
//                // read header and get body data
//                guard let decodedBodyDataCount = try parser.read(bytes: 4).toUInt32(from: .littleEndian) else {
//                    throw TestResourceError.corruptData
//                }
//                guard let encodedBodyDataCount = try parser.read(bytes: 4).toUInt32(from: .littleEndian) else {
//                    throw TestResourceError.corruptData
//                }
//                let bodyData = Data(try parser.read(bytes: Int(encodedBodyDataCount)))
//                
//                // check footer
//                let footerData = try parser.read(bytes: footer.count)
//                guard footerData == footer else {
//                    throw TestResourceError.corruptData
//                }
//                guard parser.remainingByteCount == 0 else {
//                    throw TestResourceError.corruptData
//                }
//                
//                // decompress body data
//                
//                // after extensive research and trial-and-error, there wasn't a simple way to repack Apple's LZ4 compression format
//                // to a format that was compatible with SWCompression
//                //     let decompressedData = try LZ4.decompress(data: bodyData)
//                //     guard decompressedData.count == decodedBodyDataCount else {
//                //         throw TestResourceError.corruptData
//                //     }
//                //     return decompressedData
//                
//                throw TestResourceError.notSupported
//                
//            } else if header == uncompressedHeader {
//                // read header and get body data
//                guard let bodyDataCount = try parser.read(bytes: 4).toUInt32(from: .littleEndian) else {
//                    throw TestResourceError.corruptData
//                }
//                let bodyData = try parser.read(bytes: Int(bodyDataCount))
//                
//                // check footer
//                let footerData = try parser.read(bytes: footer.count)
//                guard footerData == footer else {
//                    throw TestResourceError.corruptData
//                }
//                guard parser.remainingByteCount == 0 else {
//                    throw TestResourceError.corruptData
//                }
//                
//                // body data is uncompressed, so we don't need to make any calls to the decompressor.
//                return Data(bodyData) // create copy of data from range pointer
//                
//            } else {
                throw TestResourceError.invalidDataHeader
//            }
//        }
        #else
        throw TestResourceError.notSupported
        #endif
    }
}

// MARK: - Static Constructors

#if !canImport(Darwin)
@available(*, unavailable, message: "Not yet available on this platform.")
#endif
extension TestResource.CompressedFile.Algorithm where Self == TestResource.CompressedFile.LZ4CompressionAlgorithm {
    /// The LZ4 compression algorithm, recommended for fast compression.
    ///
    /// Use this algorithm if speed is critical, and you’re willing to sacrifice compression ratio to achieve it.
    public static var lz4: TestResource.CompressedFile.LZ4CompressionAlgorithm {
        TestResource.CompressedFile.LZ4CompressionAlgorithm()
    }
}

#endif
