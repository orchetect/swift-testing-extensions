//
//  API-0.3.0.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

// MARK: - 0.3.0 API Deprecations

#if canImport(Testing)

extension TestResource.CompressedFile.Algorithm where Self == TestResource.CompressedFile.DeflateCompressionAlgorithm {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "deflate")
    public static var zlib: TestResource.CompressedFile.DeflateCompressionAlgorithm {
        .deflate
    }
}

#endif
