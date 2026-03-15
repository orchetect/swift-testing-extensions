//
//  CompressedFile+Utilities.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

#if canImport(Darwin)
import class Foundation.Bundle
import struct Foundation.Data
import class Foundation.FileManager
import struct Foundation.URL
#else
import class Foundation.Bundle
import struct FoundationEssentials.Data
import class FoundationEssentials.FileManager
import struct FoundationEssentials.URL
#endif

import Testing

extension TestResource.CompressedFile {
    /// Utility to compress a test target resource file (non-archive).
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
    /// > It is designed to be used temporarily one time to compress a resource file for inclusion in a test target.
    @available(
        *,
        deprecated,
        message: "Note that this method is a manual utility and should not be left in code or automated testing."
    )
    public func manuallyCompressFile(locatedIn inputFolder: URL) throws {
        let inputFile = inputFolder.appendingPathComponent(fileNameWithoutCompressionSuffix)
        let data = try Data(contentsOf: inputFile)
        let compressed = try compressionAlgorithm.compress(data: data)
        let outURL = inputFolder.appendingPathComponent(fileName)
        guard !FileManager.default.fileExists(atPath: outURL.path) else {
            throw TestResourceError.fileExists
        }
        try compressed.write(to: outURL)
    }
    
    /// Utility to decompress a compressed test target resource file (non-archive).
    ///
    /// > Tip:
    /// > This method is best run from a temporary test method within the same test target as the resource file.
    /// > Ensure that the test method call is deleted after running it.
    ///
    /// > Important:
    /// > This method is a standalone manual utility and is not meant to be run as a part of automated testing.
    /// > It is designed to be used one time to decompress a resource file, usually for the purposes of editing
    /// > the file in order to be recompressed again and replaced in the test target.
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

#endif
