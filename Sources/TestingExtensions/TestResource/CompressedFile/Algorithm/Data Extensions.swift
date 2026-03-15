//
//  Data Extensions.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Darwin)
// Apple platforms

import struct Foundation.Data
import class Foundation.NSData

extension Data {
    /// Convenience to compress Data using built-in `NSData` compression algorithms on Apple platforms.
    @_disfavoredOverload
    func compressed(
        using algorithm: NSData.CompressionAlgorithm
    ) throws -> Data {
        try (self as NSData)
            .compressed(using: algorithm) as Data
    }
    
    /// Convenience to decompress Data using built-in `NSData` compression algorithms on Apple platforms.
    @_disfavoredOverload
    func decompressed(
        using algorithm: NSData.CompressionAlgorithm
    ) throws -> Data {
        try (self as NSData)
            .decompressed(using: algorithm) as Data
    }
}

#endif
