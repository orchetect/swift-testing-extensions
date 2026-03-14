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
        case .lzfse: .lzfse
        case .lz4: .lz4
        case .lzma: .lzma
        case .deflate: .zlib
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
        case .lzfse: // not yet supported
            throw TestResourceError.notSupported
        case .lz4: // supported
            return LZ4.compress(data: self)
        case .lzma: // not yet supported
            throw TestResourceError.notSupported
        case .zlib: // supported
            return Deflate.compress(data: self)
        }
    }
    
    /// Decompress data.
    func decompressed(
        using algorithm: TestResource.CompressionAlgorithm
    ) throws -> Data {
        switch algorithm {
        case .lzfse: // not yet supported
            throw TestResourceError.notSupported
        case .lz4: // supported
            return try LZ4.decompress(data: self)
        case .lzma: // supported
            return try LZMA.decompress(data: self)
        case .zlib: // supported
            return try Deflate.decompress(data: self)
        }
    }
}

#endif
