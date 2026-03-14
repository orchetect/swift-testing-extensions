//
//  API-0.3.0.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

// MARK: - 0.3.0 API Deprecations

extension TestResource.CompressionAlgorithm {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "deflate")
    public var zlib: Self { .deflate }
}
