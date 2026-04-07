//
//  TestResource.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

import TestingExtensions

extension TestResource {
    static let foo = TestResource.File(
        name: "Foo", ext: "txt", subFolder: "ResourceFiles"
    )
    
    static let bar = TestResource.File(
        name: "Bar", ext: "txt", subFolder: "ResourceFiles"
    )
    
    static let baz = TestResource.File(
        name: "Baz", ext: "bin", subFolder: "ResourceFiles"
    )
}

extension TestResource {
    /// This file on disk is available in compressed form using all of the available algorithms.
    /// These files were compressed using the algorithms provided by `NSData` on Apple platforms.
    static func bar(_ algorithm: any CompressedFile.Algorithm) -> TestResource.CompressedFile {
        TestResource.CompressedFile(
            name: "Bar", ext: "txt", subFolder: "ResourceFiles", compression: algorithm
        )
    }
    
    /// This file on disk is available in compressed form using all of the available algorithms.
    /// These files were compressed using the algorithms provided by `NSData` on Apple platforms.
    ///
    /// > Note:
    /// >
    /// > The `*.lz4`, `*.lzma` and `*.lzfse` derived from `Bar.txt` contain uncompressed plaintext
    /// > because the `Bar.txt` source file is so small. In order to coax the algorithms into actually
    /// > compressing data, we need to use more source data.)
    static func baz(_ algorithm: any CompressedFile.Algorithm) -> TestResource.CompressedFile {
        TestResource.CompressedFile(
            name: "Baz", ext: "bin", subFolder: "ResourceFiles", compression: algorithm
        )
    }
}
