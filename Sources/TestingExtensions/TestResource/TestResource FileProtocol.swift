//
//  TestResource FileProtocol.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Testing

extension TestResource {
    public protocol FileProtocol: Equatable, Hashable, Sendable {
        var name: String { get }
        var ext: String? { get }
        var subFolder: String? { get }
    }
}

extension TestResource.FileProtocol {
    /// Returns the full filename including extension, if any.
    @inline(__always)
    public var fileName: String {
        var fn = name
        if let ext { fn += ".\(ext)" }
        return fn
    }
    
    /// Returns the file URL for the resource file or `nil` if the file could not be located.
    /// This method also returns `nil` if the bundle does not exist is not a readable directory.
    @inline(__always)
    public func url(
        bundle: Bundle = #moduleBundle,
        sourceLocation: SourceLocation = #_sourceLocation
    ) throws -> URL {
        // Note: Bundle.module is synthesized when the package target has `resources: [...]`
        try #require(
            bundle.url(
                forResource: self.name,
                withExtension: self.ext,
                subdirectory: self.subFolder
            ),
            "Test resource file not found or is not accessible.",
            sourceLocation: sourceLocation
        )
    }
    
    /// Returns the contents of the test resource file or `nil` if the file could not be located.
    /// This method also returns `nil` if the bundle does not exist is not a readable directory.
    @inline(__always)
    func _rawData(
        bundle: Bundle,
        sourceLocation: SourceLocation = #_sourceLocation
    ) throws -> Data {
        let fileURL = try url(bundle: bundle, sourceLocation: sourceLocation)
        let data = try Data(contentsOf: fileURL)
        return data
    }
}

// This default implementation is suitable for both `File` and `CompressedFile`
extension TestResource.FileProtocol /* : Equatable */ {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name &&
        lhs.ext == rhs.ext &&
        lhs.subFolder == rhs.subFolder
    }
}

// This default implementation is suitable for both `File` and `CompressedFile`
extension TestResource.FileProtocol /* : Hashable */ {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(ext)
        hasher.combine(subFolder)
    }
}
