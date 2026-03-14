//
//  CompressionAlgorithm.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

extension TestResource {
    /// Platform-agnostic enumeration of supported data compression algorithms.
    ///
    /// On Apple platforms, these cases map to `NSData.CompressionAlgorithm`.
    /// On non-Apple platforms (ie: Linux), these cases map to types supported by the 3rd-party `SWCompression` dependency.
    public enum CompressionAlgorithm {
        /// The DEFLATE compression algorithm (used by `zlib`), recommended for cross-platform compression.
        /// This compresses and decompresses using the raw DEFLATE algorithm.
        ///
        /// Use this algorithm if your app requires interoperability with non-Apple devices.
        /// For example, if you are transferring data to another device where it needs to be compressed or decompressed.
        case deflate
        
        /// The LZ4 compression algorithm, recommended for fast compression.
        ///
        /// Use this algorithm if speed is critical, and you’re willing to sacrifice compression ratio to achieve it.
        case lz4
        
        /// The LZFSE compression algorithm, recommended for use on Apple platforms.
        ///
        /// The algorithm offers faster speed and generally achieves better compression than DEFLATE (used by `zlib`).
        /// However, it is slower than `lz4` and doesn’t compress as well as `lzma`.
        ///
        /// Apple claims that LZFSE compresses with a ratio comparable to that of DEFLATE (used by `zlib`) and
        /// decompresses 2-to-3 times faster while using fewer resources, offering higher energy efficiency than DEFLATE.
        case lzfse
        
        /// The LZMA compression algorithm, recommended for high-compression ratio.
        ///
        /// Use this algorithm if compression ratio is critical, and you’re willing to sacrifice speed to achieve it.
        /// It is an order of magnitude slower for both compression and decompression than other choices.
        case lzma
    }
}

extension TestResource.CompressionAlgorithm: Equatable { }

extension TestResource.CompressionAlgorithm: Hashable { }

extension TestResource.CompressionAlgorithm: Sendable { }

extension TestResource.CompressionAlgorithm {
    /// Returns the suggested file extension for use with the compression algorithm.
    public var fileExtension: String {
        switch self {
        case .deflate: "deflate"
        case .lz4: "lz4"
        case .lzfse: "lzfse"
        case .lzma: "lzma"
        }
    }
}
