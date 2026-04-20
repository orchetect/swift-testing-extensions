//
//  Utilities.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

import SwiftSyntax
import SwiftSyntaxMacros

extension LabeledExprListSyntax {
    /// Retrieve the first element with the given label.
    func first(labeled name: String) -> Element? {
        first { element in
            if let label = element.label, label.text == name {
                return true
            }

            return false
        }
    }
}
