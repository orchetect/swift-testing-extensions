//
//  TestResource CompressedFile.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Testing

extension TestResource {
    /// Metadata describing a test resource file that exists in the test target.
    public struct CompressedFile: FileProtocol {
        public let name: String
        
        private let _ext: String?
        @inline(__always)
        public var ext: String? { ext(compressedForm: true) }
        
        public let subFolder: String?
        
        public let compression: NSData.CompressionAlgorithm
        
        public init(
            name: String,
            ext: String? = nil,
            subFolder: String? = nil,
            compression: NSData.CompressionAlgorithm
        ) {
            self.name = name
            self._ext = ext
            self.subFolder = subFolder
            self.compression = compression
        }
        
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
                components.append(compression.fileExtension)
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
            let decompressedData = try compressedData.decompressed(using: compression)
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
}

// MARK: - Utilities

extension TestResource.CompressedFile {
    /// Utility to compress a test resource file.
    ///
    /// This method can be run manually when ingesting a file for storage in the package.
    /// After compression, the file can be moved to the package within the test target's `/TestResource/X/` subfolder
    /// (where `X` is an appropriate subfolder to contain the file).
    ///
    /// After this method runs successfully, the compressed file will be output in the same folder as the `inputFolder`
    /// with the same filename but appending an extension based on the compression type.
    ///
    /// For Example:
    /// - With a base filename of `"foo"` and an extension of `"txt"` using `lzfse` compression, the compressed file
    ///   will be named `"foo.txt.lzfse"`
    /// - With a base filename of `"foo"` (without an extension) using `lzfse` compression, the compressed file
    ///   will be named `"foo.lzfse"`
    ///
    /// > Tip:
    /// > This method is best run from a temporary test method within the same test target as the resource file.
    /// > Ensure that the test method call is deleted after running it.
    ///
    /// > Important:
    /// > This method is a standalone manual utility and is not meant to be run as a part of automated testing.
    /// > It is designed to be used temporarily one time to compress a resource file.
    @available(
        *,
        deprecated,
        message: "Note that this method is a manual utility and should not be left in code or automated testing."
    )
    public func manuallyCompressFile(locatedIn inputFolder: URL) throws {
        let inputFile = inputFolder.appendingPathComponent(fileNameWithoutCompressionSuffix)
        let data = try Data(contentsOf: inputFile)
        let compressed = try data.compressed(using: compression)
        let outURL = inputFolder.appendingPathComponent(fileName)
        guard !FileManager.default.fileExists(atPath: outURL.path) else {
            throw CocoaError(.fileWriteFileExists)
        }
        try compressed.write(to: outURL)
    }
    
    /// Utility to decompress a test compressed resource file to the desktop.
    ///
    /// > Tip:
    /// > This method is best run from a temporary test method within the same test target as the resource file.
    /// > Ensure that the test method call is deleted after running it.
    ///
    /// > Important:
    /// > This method is a standalone manual utility and is not meant to be run as a part of automated testing.
    /// > It is designed to be used one time to decompress a resource file, usually for the purposes of editing
    /// > the file in order to be recompressed again and replaced in the package at a later time.
    /// >
    /// > For use in automated testing, call the `data()` method instead to return the uncompressed raw file content.
    @available(
        *,
        deprecated,
        message: "Note that this method is a manual utility and should not be left in code or automated testing."
    )
    public func manuallyDecompress(
        intoFolder outputFolder: URL,
        bundle: Bundle = #moduleBundle
    ) throws {
        let decompressedData = try data(bundle: bundle)
        let outURL = outputFolder.appendingPathComponent(fileNameWithoutCompressionSuffix)
        try decompressedData.write(to: outURL)
    }
}
