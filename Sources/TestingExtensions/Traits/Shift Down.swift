//
//  Shift Down.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

import Testing

#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// Returns `true` if the keyboard **Shift** key is currently pressed by the user.
/// Note that this only applies to tests running on macOS. On other platforms, `false`
/// is always returned.
public func isShiftOnlyDown() -> Bool {
    #if os(macOS)
    let flags = NSEvent.modifierFlags
    let invalidFlags: [NSEvent.ModifierFlags] = [.command, .control, .option]
    return flags.contains(.shift) &&
        invalidFlags.allSatisfy { !flags.contains($0) }
    #else
    return false
    #endif
}

extension Trait where Self == Testing.ConditionTrait {
    /// Convenience proxy for `.enabled(if: isShiftOnlyDown())`.
    ///
    /// This can be useful where development tests exist in a testing target that may perform
    /// a long-running or destructive action in the system, and are thus intended to only
    /// be run ad-hoc by the developer on a testing machine running in the Xcode IDE, and not
    /// meant to run as part of automatic unit testing.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabledIfShiftOnlyIsDown) func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    public static var enabledIfShiftOnlyIsDown: ConditionTrait {
        .enabled(if: isShiftOnlyDown())
    }
}

#endif
