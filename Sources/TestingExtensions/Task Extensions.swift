//
//  Task Extensions.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task where Success == Never, Failure == Never {
    /// Suspends the current task for at least the given duration
    /// in seconds.
    ///
    /// If the task is canceled before the time ends,
    /// this function throws `CancellationError`.
    ///
    /// This function doesn't block the underlying thread.
    @_disfavoredOverload
    package static func sleep(seconds: TimeInterval) async throws {
        let intervalNS = UInt64(seconds * TimeInterval(NSEC_PER_SEC))
        try await sleep(nanoseconds: intervalNS)
    }
}

#endif
