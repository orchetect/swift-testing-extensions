//
//  Wait.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(Testing)

import Testing

/// Wait for a boolean condition, failing an expectation if the condition times out without evaluating to `true`.
public func wait(
    expect condition: @Sendable () async throws -> Bool,
    timeout: TimeInterval,
    pollingInterval: TimeInterval = 0.1,
    _ comment: Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) async rethrows {
    let timeout = max(timeout, 0.001) // sanitize: clamp
    let pollingInterval = max(pollingInterval, 0.001) // sanitize: clamp
    
    let pollingIntervalNS = UInt64(pollingInterval * TimeInterval(NSEC_PER_SEC))
    
    let startTime = Date()
    
    while Date().timeIntervalSince(startTime) < timeout {
        if try await condition() { return }
        try? await Task.sleep(nanoseconds: pollingIntervalNS)
    }
    
    #expect(try await condition(), comment, sourceLocation: sourceLocation)
}

/// Wait for a boolean condition, throwing an error if the condition times out without evaluating to `true`.
public func wait(
    require condition: @Sendable () async throws -> Bool,
    timeout: TimeInterval,
    pollingInterval: TimeInterval = 0.1,
    _ comment: Testing.Comment? = nil,
    sourceLocation: Testing.SourceLocation = #_sourceLocation
) async throws {
    let timeout = max(timeout, 0.001) // sanitize: clamp
    let pollingInterval = max(pollingInterval, 0.001) // sanitize: clamp
    
    let pollingIntervalNS = UInt64(pollingInterval * TimeInterval(NSEC_PER_SEC))
    
    let startTime = Date()
    
    while Date().timeIntervalSince(startTime) < timeout {
        if try await condition() { return }
        try await Task.sleep(nanoseconds: pollingIntervalNS)
    }
    
    try #require(await condition(), comment, sourceLocation: sourceLocation)
}

#endif
