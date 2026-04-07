//
//  Algorithm+LZMA2XZ.swift
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
import SWCompression
#endif

extension TestResource.CompressedFile {
    /// The LZMA2 compression algorithm archived within an XZ container, recommended for high-compression ratio.
    ///
    /// Use this algorithm if compression ratio is critical, and you’re willing to sacrifice speed to achieve it.
    /// It is an order of magnitude slower for both compression and decompression than other choices.
    public struct LZMA2XZCompressionAlgorithm {
        public init() { }
    }
}

extension TestResource.CompressedFile.LZMA2XZCompressionAlgorithm: Equatable { }

extension TestResource.CompressedFile.LZMA2XZCompressionAlgorithm: Hashable { }

extension TestResource.CompressedFile.LZMA2XZCompressionAlgorithm: Sendable { }

extension TestResource.CompressedFile.LZMA2XZCompressionAlgorithm: TestResource.CompressedFile.Algorithm {
    public var fileExtension: String {
        "xz"
    }

    #if !canImport(Darwin)
    @available(*, deprecated, message: "Not yet available on this platform.")
    #endif
    public func compress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression, which implements LZMA level 6
        try data.compressed(using: .lzma)
        #elseif os(Linux)
        // TODO: not yet supported by SWCompression
        throw TestResourceError.notSupported
        #else
        throw TestResourceError.notSupported
        #endif
    }

    public func decompress(data: Data) throws -> Data {
        #if canImport(Darwin)
        // use Apple-provided NSData compression, which implements LZMA level 6
        try data.decompressed(using: .lzma)
        #elseif os(Linux)
        // use 3rd-party SWCompression dependency provided method
        try XZArchive.unarchive(archive: data) // unarchives LZMA2 packed inside an XZ container
        #else
        throw TestResourceError.notSupported
        #endif
    }
}

// MARK: - Static Constructors

extension TestResource.CompressedFile.Algorithm where Self == TestResource.CompressedFile.LZMA2XZCompressionAlgorithm {
    /// The LZMA2 compression algorithm archived within an XZ container, recommended for high-compression ratio.
    ///
    /// Use this algorithm if compression ratio is critical, and you’re willing to sacrifice speed to achieve it.
    /// It is an order of magnitude slower for both compression and decompression than other choices.
    public static var lzma2xz: TestResource.CompressedFile.LZMA2XZCompressionAlgorithm {
        TestResource.CompressedFile.LZMA2XZCompressionAlgorithm()
    }
}

#endif
