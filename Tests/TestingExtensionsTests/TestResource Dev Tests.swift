//
//  TestResource Dev Tests.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import class Foundation.Bundle
import class Foundation.FileManager
import struct Foundation.URL
import Testing
@testable import TestingExtensions

/// This test is not part of automated CI testing.
/// This is just a manually-invoked utility to compress or decompress files ad-hoc.
@Test(.enabledIfShiftOnlyIsDown)
func manualCompressionUtility() {
//    try TestResource.baz(.lz4).manuallyCompressFile(locatedIn: .desktopDirectory)
//    try TestResource.baz(.lz4).manuallyDecompress(intoFolder: .desktopDirectory)
}

#endif
