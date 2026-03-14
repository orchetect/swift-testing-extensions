//
//  Data Compression.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
// Apple platforms

import struct Foundation.Data
import class Foundation.NSData

extension TestResource.CompressionAlgorithm {
    var nsDataCompressionAlgorithm: NSData.CompressionAlgorithm {
        switch self {
        case .deflate: .zlib
        case .lz4: .lz4
        case .lzfse: .lzfse
        case .lzma: .lzma
        }
    }
}

extension Data {
    func compressed(
        using algorithm: TestResource.CompressionAlgorithm
    ) throws -> Data {
        try compressed(using: algorithm.nsDataCompressionAlgorithm)
    }
    
    /// Decompress data.
    func decompressed(
        using algorithm: TestResource.CompressionAlgorithm
    ) throws -> Data {
        try decompressed(using: algorithm.nsDataCompressionAlgorithm)
    }
}

extension Data {
    /// Compress data.
    @_disfavoredOverload
    func compressed(
        using algorithm: NSData.CompressionAlgorithm
    ) throws -> Data {
        try (self as NSData)
            .compressed(using: algorithm) as Data
    }
    
    /// Decompress data.
    @_disfavoredOverload
    func decompressed(
        using algorithm: NSData.CompressionAlgorithm
    ) throws -> Data {
        try (self as NSData)
            .decompressed(using: algorithm) as Data
    }
}

#else
// Linux and Windows

import struct FoundationEssentials.Data
import SWCompression

extension Data {
    /// Compress data.
    func compressed(
        using algorithm: TestResource.CompressionAlgorithm
    ) throws -> Data {
        switch algorithm {
        case .deflate: // supported
            return Deflate.compress(data: self)
            
        case .lz4: // supported
            // note that Apple's LZ4 (not LZ4 RAW) adds an 8-byte header and a 4-byte footer.
            // SWCompression does not add them when compressing, nor does it expect them when decoding.
            // So we should add them after encoding using SWCompression.
            // See: https://developer.apple.com/documentation/compression/compression_lz4
            // TODO: add header and footer bytes
            return LZ4.compress(data: self)
            
        case .lzfse: // not yet supported
            throw TestResourceError.notSupported
            
        case .lzma: // not yet supported
            throw TestResourceError.notSupported
        }
    }
    
    /// Decompress data.
    func decompressed(
        using algorithm: TestResource.CompressionAlgorithm
    ) throws -> Data {
        switch algorithm {
        case .deflate: // supported
            return try Deflate.decompress(data: self)
            
        case .lz4: // supported
            // note that Apple's LZ4 (not LZ4 RAW) adds an 8-byte header and a 4-byte footer.
            // SWCompression does not add them when compressing, nor does it expect them when decoding.
            // So we should trim them off before decoding using SWCompression.
            // See: https://developer.apple.com/documentation/compression/compression_lz4
            // TODO: strip header and footer bytes
            return try LZ4.decompress(data: self)
            
        case .lzfse: // not yet supported
            throw TestResourceError.notSupported
            
        case .lzma: // supported
            return try LZMA.decompress(data: self)
        }
    }
}

#endif
