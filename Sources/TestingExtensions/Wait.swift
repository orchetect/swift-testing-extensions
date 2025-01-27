//
//  Wait.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

import Testing

/// Wait for a boolean condition, failing an expectation if the condition times out without evaluating to `true`.
func wait(
    expect condition: @Sendable () async throws -> Bool,
    timeout: TimeInterval,
    pollingInterval: TimeInterval = 0.1,
    _ comment: Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) async rethrows {
    let pollingIntervalNS = UInt64(pollingInterval * TimeInterval(NSEC_PER_SEC))
    
    let startTime = Date()
    
    while Date().timeIntervalSince(startTime) < timeout {
        if try await condition() { return }
        try? await Task.sleep(nanoseconds: pollingIntervalNS)
    }
    
    #expect(try await condition(), comment, sourceLocation: sourceLocation)
}

/// Wait for a boolean condition, throwing an error if the condition times out without evaluating to `true`.
func wait(
    require condition: @Sendable () async throws -> Bool,
    timeout: TimeInterval,
    pollingInterval: TimeInterval = 0.1,
    _ comment: Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) async throws {
    let pollingIntervalNS = UInt64(pollingInterval * TimeInterval(NSEC_PER_SEC))
    
    let startTime = Date()
    
    while Date().timeIntervalSince(startTime) < timeout {
        if try await condition() { return }
        try await Task.sleep(nanoseconds: pollingIntervalNS)
    }
    
    try #require(await condition(), comment, sourceLocation: sourceLocation)
}

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
    static func sleep(seconds: TimeInterval) async throws {
        let intervalNS = UInt64(seconds * TimeInterval(NSEC_PER_SEC))
        try await sleep(nanoseconds: intervalNS)
    }
}


#endif
