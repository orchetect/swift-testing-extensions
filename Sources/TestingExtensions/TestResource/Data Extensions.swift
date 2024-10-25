//
//  Data Extensions.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// Apple claims that LZFSE compresses with a ratio comparable to that of zlib (DEFLATE) and
// decompresses two to three times faster while using fewer resources, therefore offering higher energy efficiency than zlib.
extension Data {
    /// Compress data.
    func compressed(
        using algo: NSData.CompressionAlgorithm = .lzfse
    ) throws -> Data {
        try (self as NSData).compressed(using: algo) as Data
    }
    
    /// Decompress data.
    func decompressed(
        using algo: NSData.CompressionAlgorithm = .lzfse
    ) throws -> Data {
        try (self as NSData).decompressed(using: algo) as Data
    }
}

extension NSData.CompressionAlgorithm {
    var fileExtension: String {
        switch self {
        case .lz4: return "lz4"
        case .lzfse: return "lzfse"
        case .lzma: return "lzma"
        case .zlib: return "zlib"
        @unknown default:
            assertionFailure("Unhandled case: \(self)")
            return "compressed"
        }
    }
}
