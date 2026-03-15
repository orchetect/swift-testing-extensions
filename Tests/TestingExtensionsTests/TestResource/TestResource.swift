//
//  TestResource.swift
//  swift-testing-extensions
//
//  Created by Steffan Andrews on 2026-03-14.
//

import TestingExtensions

extension TestResource {
    static let foo = TestResource.File(
        name: "Foo", ext: "txt", subFolder: "ResourceFiles"
    )
    
    /// This file on disk is available in compressed form using all of the available algorithms.
    /// These files were compressed using the algorithms provided by `NSData` on Apple platforms.
    static func bar(_ algorithm: any CompressedFile.Algorithm) -> TestResource.CompressedFile {
        TestResource.CompressedFile(
            name: "Bar", ext: "txt", subFolder: "ResourceFiles", compression: algorithm
        )
    }
    
    /// This file is compressed using LZ4 in order to test compressed LZ4 data decompression.
    /// (Note the `Bar.txt.lz4` resource file is an uncompressed plaintext LZ4 block.)
    static let baz = TestResource.CompressedFile(
        name: "Baz", ext: "bin", subFolder: "ResourceFiles", compression: .lz4
    )
}
