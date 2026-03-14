//
//  Compression+LZMA.swift
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
    /// The LZMA compression algorithm, recommended for high-compression ratio.
    ///
    /// Use this algorithm if compression ratio is critical, and you’re willing to sacrifice speed to achieve it.
    /// It is an order of magnitude slower for both compression and decompression than other choices.
    public struct LZMACompression {
        public init() { }
    }
}

extension TestResource.LZMACompression: Equatable { }

extension TestResource.LZMACompression: Hashable { }

extension TestResource.LZMACompression: Sendable { }

extension TestResource.LZMACompression: TestResource.Compression {
    public var fileExtension: String {
        "lzma"
    }

    public func compress(data: Data) throws -> Data {
        #if canImport(Darwin)
        try data.compressed(using: .lzma)
        #else
        // TODO: not yet supported
        throw TestResourceError.notSupported
        #endif
    }

    public func decompress(data: Data) throws -> Data {
        #if canImport(Darwin)
        try data.decompressed(using: .lzma)
        #else
        try LZMA.decompress(data: self)
        #endif
    }
}

// MARK: - Static Constructors

extension TestResource.Compression where Self == TestResource.LZMACompression {
    /// The LZMA compression algorithm, recommended for high-compression ratio.
    ///
    /// Use this algorithm if compression ratio is critical, and you’re willing to sacrifice speed to achieve it.
    /// It is an order of magnitude slower for both compression and decompression than other choices.
    public static var lzma: TestResource.LZMACompression {
        TestResource.LZMACompression()
    }
}
