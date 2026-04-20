//
//  Data+CompressionFramework.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)

import Compression
import struct Foundation.Data

extension compression_algorithm {
    static var brotli: Self {
        COMPRESSION_BROTLI
    }

    static var lz4: Self {
        COMPRESSION_LZ4
    }

    static var lz4Raw: Self {
        COMPRESSION_LZ4_RAW
    }

    static var lzbitmap: Self {
        COMPRESSION_LZBITMAP
    }

    static var lzfse: Self {
        COMPRESSION_LZFSE
    }

    static var lzma: Self {
        COMPRESSION_LZMA
    }

    static var zlib: Self {
        COMPRESSION_ZLIB
    }
}

extension Data {
    /// Default decompression buffer size.
    private static let defaultDecompressCapacity = (2 ^ 20) * 8 // 8MB

    /// Compress data using Apple's Compression Framework.
    ///
    /// - Parameters:
    ///   - algorithm: Compression algorithm to use.
    func compressUsingCompressionFramework(algorithm: compression_algorithm) throws(TestResourceError) -> Data {
        // create an array of UInt8 from the data
        var sourceBuffer = Array(self)
        let sourceSize = count

        // output buffer
        let outputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: sourceSize)
        defer {
            outputBuffer.deallocate()
        }

        // compress the data with a given algorithm
        let compressedSize = compression_encode_buffer(
            outputBuffer,
            sourceSize,
            &sourceBuffer,
            sourceSize,
            nil,
            algorithm
        )

        // if the compressed data can't fit into the output buffer or an error occurs 0 is returned
        if compressedSize == 0 {
            throw TestResourceError.compressionFailed
        }

        // convert bytes to Data
        return Data(bytes: outputBuffer, count: compressedSize)
    }

    /// Decompress data using Apple's Compression Framework.
    ///
    /// - Parameters:
    ///   - algorithm: Compression algorithm used to originally compress the data.
    ///   - uncompressedSize: Size of the uncompressed data in bytes, if known. This determines the decompression buffer size.
    func decompressUsingCompressionFramework(algorithm: compression_algorithm, uncompressedSize: Int? = nil) -> Data {
        let decompressCapacity = uncompressedSize ?? Self.defaultDecompressCapacity

        // output buffer
        let outputBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: decompressCapacity)
        defer {
            outputBuffer.deallocate()
        }

        // decompress and return the output byte length
        let decodedBytesCount: Int = withUnsafeBytes { encodedSourceBuffer in
            let bytesPointer = encodedSourceBuffer.bindMemory(to: UInt8.self)

            // decompress the data
            let decodedBytesCount = compression_decode_buffer(
                outputBuffer,
                decompressCapacity,
                bytesPointer.baseAddress!,
                count,
                nil,
                algorithm
            )
            return decodedBytesCount
        }

        // convert bytes to Data
        return Data(bytes: outputBuffer, count: decodedBytesCount)
    }
}

#endif
