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
}
