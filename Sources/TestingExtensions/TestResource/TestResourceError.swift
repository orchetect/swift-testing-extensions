//
//  TestResourceError.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

public enum TestResourceError: Error {
    case corruptData
    case fileExists
    case invalidDataFooter
    case invalidDataHeader
    case notEnoughData
    case notSupported
}

extension TestResourceError: Equatable { }

extension TestResourceError: Hashable { }

extension TestResourceError: Sendable { }

extension TestResourceError {
    public var localizedDescription: String {
        switch self {
        case .corruptData:
            "Data is corrupt."
        case .fileExists:
            "File already exists."
        case .invalidDataFooter:
            "Invalid data footer."
        case .invalidDataHeader:
            "Invalid data header."
        case .notEnoughData:
            "Not enough data."
        case .notSupported:
            "Feature is not yet supported."
        }
    }
}
