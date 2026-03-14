//
//  TestResourceError.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

public enum TestResourceError: Error {
    case fileExists
}

extension TestResourceError: Equatable { }

extension TestResourceError: Hashable { }

extension TestResourceError: Sendable { }

extension TestResourceError {
    public var localizedDescription: String {
        switch self {
        case .fileExists:
            "File already exists."
        }
    }
}
