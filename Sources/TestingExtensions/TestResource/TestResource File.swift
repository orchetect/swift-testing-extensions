//
//  TestResource File.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Testing

extension TestResource {
    /// Metadata describing a test resource file that exists in the test target.
    public struct File: FileProtocol {
        public let name: String
        public let ext: String?
        public let subFolder: String?
        
        public init(
            name: String,
            ext: String? = nil,
            subFolder: String? = nil
        ) {
            self.name = name
            self.ext = ext
            self.subFolder = subFolder
        }
        
        /// Returns the contents of the test resource file or `nil` if the file could not be located.
        /// This method also returns `nil` if the bundle does not exist is not a readable directory.
        @inline(__always)
        public func data(
            bundle: Bundle = #moduleBundle,
            sourceLocation: SourceLocation = #_sourceLocation
        ) throws -> Data {
            try _rawData(bundle: bundle, sourceLocation: sourceLocation)
        }
    }
}


// MARK: - Public Members

extension TestResource.File {
    /// Returns the full filename including extension, if any.
    @inline(__always)
    public var fileName: String {
        var fn = name
        if let ext { fn += ".\(ext)" }
        return fn
    }
}
