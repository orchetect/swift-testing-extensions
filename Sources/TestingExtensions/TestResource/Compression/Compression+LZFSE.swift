//
//  Compression+LZFSE.swift
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
    /// The LZFSE compression algorithm, recommended for use on Apple platforms.
    ///
    /// The algorithm offers faster speed and generally achieves better compression than DEFLATE (used by `zlib`).
    /// However, it is slower than `lz4` and doesn’t compress as well as `lzma`.
    ///
    /// Apple claims that LZFSE compresses with a ratio comparable to that of DEFLATE (used by `zlib`) and
    /// decompresses 2-to-3 times faster while using fewer resources, offering higher energy efficiency than DEFLATE.
    public struct LZFSECompression {
        public init() { }
    }
}

extension TestResource.LZFSECompression: Equatable { }

extension TestResource.LZFSECompression: Hashable { }

extension TestResource.LZFSECompression: Sendable { }

extension TestResource.LZFSECompression: TestResource.Compression {
    public var fileExtension: String {
        "lzfse"
    }

    public func compress(data: Data) throws -> Data {
        #if canImport(Darwin)
        try data.compressed(using: .lzfse)
        #else
        // TODO: not yet supported
        throw TestResourceError.notSupported
        #endif
    }

    public func decompress(data: Data) throws -> Data {
        #if canImport(Darwin)
        try data.decompressed(using: .lzfse)
        #else
        // TODO: not yet supported
        throw TestResourceError.notSupported
        #endif
    }
}

// MARK: - Static Constructors

extension TestResource.Compression where Self == TestResource.LZFSECompression {
    /// The LZFSE compression algorithm, recommended for use on Apple platforms.
    ///
    /// The algorithm offers faster speed and generally achieves better compression than DEFLATE (used by `zlib`).
    /// However, it is slower than `lz4` and doesn’t compress as well as `lzma`.
    ///
    /// Apple claims that LZFSE compresses with a ratio comparable to that of DEFLATE (used by `zlib`) and
    /// decompresses 2-to-3 times faster while using fewer resources, offering higher energy efficiency than DEFLATE.
    public static var lzfse: TestResource.LZFSECompression {
        TestResource.LZFSECompression()
    }
}
