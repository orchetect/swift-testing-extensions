//
//  Algorithm+LZFSE.swift
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
    /// The LZFSE compression algorithm, recommended for use on Apple platforms.
    ///
    /// The algorithm offers faster speed and generally achieves better compression than DEFLATE (used by `zlib`).
    /// However, it is slower than `lz4` and doesn’t compress as well as `lzma`.
    ///
    /// Apple claims that LZFSE compresses with a ratio comparable to that of DEFLATE (used by `zlib`) and
    /// decompresses 2-to-3 times faster while using fewer resources, offering higher energy efficiency than DEFLATE.
    #if !canImport(Darwin)
    @available(*, unavailable, message: "Not yet available on this platform.")
    #endif
    public struct LZFSECompressionAlgorithm {
        public init() { }
    }
}

#if !canImport(Darwin)
@available(*, unavailable, message: "Not yet available on this platform.")
#endif
extension TestResource.CompressedFile.LZFSECompressionAlgorithm: Equatable { }

#if !canImport(Darwin)
@available(*, unavailable, message: "Not yet available on this platform.")
#endif
extension TestResource.CompressedFile.LZFSECompressionAlgorithm: Hashable { }

#if !canImport(Darwin)
@available(*, unavailable, message: "Not yet available on this platform.")
#endif
extension TestResource.CompressedFile.LZFSECompressionAlgorithm: Sendable { }

#if !canImport(Darwin)
@available(*, unavailable, message: "Not yet available on this platform.")
#endif
extension TestResource.CompressedFile.LZFSECompressionAlgorithm: TestResource.CompressedFile.Algorithm {
    public var fileExtension: String {
        "lzfse"
    }

    public func compress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression
        try data.compressed(using: .lzfse)
        #else
        // TODO: not yet supported by SWCompression
        throw TestResourceError.notSupported
        #endif
    }

    public func decompress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression
        try data.decompressed(using: .lzfse)
        #else
        // TODO: not yet supported by SWCompression
        throw TestResourceError.notSupported
        #endif
    }
}

// MARK: - Static Constructors

#if !canImport(Darwin)
@available(*, unavailable, message: "Not yet available on this platform.")
#endif
extension TestResource.CompressedFile.Algorithm where Self == TestResource.CompressedFile.LZFSECompressionAlgorithm {
    /// The LZFSE compression algorithm, recommended for use on Apple platforms.
    ///
    /// The algorithm offers faster speed and generally achieves better compression than DEFLATE (used by `zlib`).
    /// However, it is slower than `lz4` and doesn’t compress as well as `lzma`.
    ///
    /// Apple claims that LZFSE compresses with a ratio comparable to that of DEFLATE (used by `zlib`) and
    /// decompresses 2-to-3 times faster while using fewer resources, offering higher energy efficiency than DEFLATE.
    public static var lzfse: TestResource.CompressedFile.LZFSECompressionAlgorithm {
        TestResource.CompressedFile.LZFSECompressionAlgorithm()
    }
}
