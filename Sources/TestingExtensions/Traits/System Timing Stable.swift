//
//  System Timing Stable.swift
//  Swift Testing Extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

import Testing

#if canImport(Darwin) && canImport(Foundation)
import struct Foundation.Date
import class Foundation.Thread
import typealias Foundation.TimeInterval
import var Foundation.USEC_PER_SEC // also in CoreFoundation
#else
import struct FoundationEssentials.Date
import typealias FoundationEssentials.TimeInterval
private let USEC_PER_SEC: UInt64 = 1_000_000
import func Foundation.usleep
#endif

/// Returns `true` if system conditions are suitable for executing tests that rely on precise system timing.
///
/// Test case usage:
///
/// ```swift
/// @Test(.enabledIfSystemTimingStable()) func foo() async throws {
///     // test logic...
/// }
/// ```
public func isSystemTimingStable(
    duration: TimeInterval = 0.1,
    tolerance: TimeInterval = 0.01
) -> Bool {
    let start = Date()

    #if canImport(Darwin) && canImport(Foundation)
    Thread.sleep(forTimeInterval: duration)
    #elseif os(WASI)
    usleep(UInt32(TimeInterval(USEC_PER_SEC) * duration))
    #else
    // Linux and Android use UInt64 usleep value
    usleep(UInt64(TimeInterval(USEC_PER_SEC) * duration))
    #endif

    let end = Date()
    let diff = end.timeIntervalSince(start)

    let range = (duration - tolerance) ... (duration + tolerance)
    return range.contains(diff)
}

extension Trait where Self == Testing.ConditionTrait {
    /// Convenience proxy for `.enabled(if: isSystemTimingStable())`.
    ///
    /// Returns `true` if system conditions are suitable for executing tests that rely on precise system timing.
    ///
    /// Test case usage:
    ///
    /// ```swift
    /// @Test(.enabledIfSystemTimingStable()) func foo() async throws {
    ///     // test logic...
    /// }
    /// ```
    public static func enabledIfSystemTimingStable(
        duration: TimeInterval = 0.1,
        tolerance: TimeInterval = 0.01
    ) -> ConditionTrait {
        .enabled(if: isSystemTimingStable(duration: duration, tolerance: tolerance))
    }
}

#endif
