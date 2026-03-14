//
//  System Timing Stable.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

import Testing

#if canImport(Foundation) && canImport(Dispatch)
import struct Foundation.Date
import typealias Foundation.TimeInterval
import func Foundation.usleep
import var Dispatch.USEC_PER_SEC
#else
public typealias TimeInterval = Double
private let USEC_PER_SEC: UInt64 = 1_000_000
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
    let durationUS = UInt32(duration * TimeInterval(USEC_PER_SEC))
    
    let start = Date()
    usleep(durationUS)
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
