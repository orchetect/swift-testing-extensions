//
//  CompressedFile.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

#if canImport(Darwin)
import class Foundation.Bundle
import struct Foundation.Data
#else
import class Foundation.Bundle
import struct FoundationEssentials.Data
#endif

import Testing

extension TestResource {
    /// Metadata describing a compressed test resource file that exists in the test target.
    public struct CompressedFile: FileProtocol {
        public let name: String

        private let _ext: String?

        @inline(__always)
        public var ext: String? {
            ext(compressedForm: true)
        }

        public let subFolder: String?

        public let compressionAlgorithm: any Algorithm

        public init(
            name: String,
            ext: String? = nil,
            subFolder: String? = nil,
            compression: any Algorithm
        ) {
            self.name = name
            _ext = ext
            self.subFolder = subFolder
            compressionAlgorithm = compression
        }
    }
}

// MARK: - Public Members

extension TestResource.CompressedFile {
    /// Returns the file extension in either its base non-compressed form or its compressed form.
    /// In its compressed form, a trailing compression extension is added.
    ///
    /// For Example:
    /// - With a base extension of `"txt"` using `lzfse` compression, the compressed form returns `"txt.lzfse"`
    /// - With no base extension (`nil`) using `lzfse` compression, the compressed form returns `"lzfse"`
    @inline(__always)
    public func ext(compressedForm: Bool) -> String {
        var components: [String] = []
        if let _ext { components.append(_ext) }
        if compressedForm {
            components.append(compressionAlgorithm.fileExtension)
        }
        let output = components.joined(separator: ".")
        return output
    }

    /// Returns the contents of the test resource file or `nil` if the file could not be located.
    /// This method also returns `nil` if the bundle does not exist is not a readable directory.
    @inline(__always)
    public func data(
        bundle: Bundle = #moduleBundle,
        sourceLocation: SourceLocation = #_sourceLocation
    ) throws -> Data {
        let compressedData = try _rawData(bundle: bundle)
        let decompressedData = try compressionAlgorithm.decompress(data: compressedData)
        return decompressedData
    }

    /// Returns the full filename including extension, if any, omitting the trailing compression extension.
    @inline(__always)
    public var fileNameWithoutCompressionSuffix: String {
        var fn = name
        if let _ext { fn += ".\(_ext)" }
        return fn
    }
}

#endif
