//
//  Algorithm.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

#if canImport(Darwin)
import struct Foundation.Data
#else
import struct FoundationEssentials.Data
#endif

extension TestResource.CompressedFile {
    /// Platform-agnostic interface for single-file (non-archive) data compression algorithms.
    /// To implement a custom compression algorithm, conform a type to this protocol.
    public protocol Algorithm: Equatable, Hashable, Sendable {
        /// Returns the suggested file extension for use with the compression algorithm.
        var fileExtension: String { get }

        /// Compresses data using the algorithm.
        func compress(data: Data) throws -> Data

        /// Decompresses data using the algorithm.
        func decompress(data: Data) throws -> Data
    }
}

#endif
