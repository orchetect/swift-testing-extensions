//
//  Wait Tests.swift
//  swift-testing-extensions • https://github.com/orchetect/swift-testing-extensions
//  © 2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import Testing
import TestingExtensions

@Suite struct WaitTests {
    @MainActor @Test
    func waitExpect() async throws {
        let isStable = isSystemTimingStable()
        
        actor Foo {
            var value = 0
            func update(value: Int) { self.value = value }
        }
        
        let foo = Foo()
        
        Task {
            try await Task.sleep(seconds: 0.5)
            await foo.update(value: 1)
        }
        
        #expect(await foo.value == 0)
        
        await wait(expect: { await foo.value == 1 }, timeout: isStable ? 1.0 : 5.0)
    }
    
    @MainActor @Test
    func tryWaitExpect() async throws {
        let isStable = isSystemTimingStable()
        
        actor Foo {
            var value = 0
            func getValue() throws -> Int { value }
            func update(value: Int) { self.value = value }
        }
        
        let foo = Foo()
        
        Task {
            try await Task.sleep(seconds: 0.5)
            await foo.update(value: 1)
        }
        
        #expect(await foo.value == 0)
        
        try await wait(expect: { try await foo.getValue() == 1 }, timeout: isStable ? 1.0 : 5.0)
    }
    
    @MainActor @Test
    func waitRequire() async throws {
        let isStable = isSystemTimingStable()
        
        actor Foo {
            var value = 0
            func update(value: Int) { self.value = value }
        }
        
        let foo = Foo()
        
        Task {
            try await Task.sleep(seconds: 0.5)
            await foo.update(value: 1)
        }
        
        #expect(await foo.value == 0)
        
        try await wait(require: { await foo.value == 1 }, timeout: isStable ? 1.0 : 5.0)
    }
    
    @MainActor @Test
    func tryWaitRequire() async throws {
        let isStable = isSystemTimingStable()
        
        actor Foo {
            var value = 0
            func getValue() throws -> Int { value }
            func update(value: Int) { self.value = value }
        }
        
        let foo = Foo()
        
        Task {
            try await Task.sleep(seconds: 0.5)
            await foo.update(value: 1)
        }
        
        #expect(await foo.value == 0)
        
        try await wait(require: { try await foo.getValue() == 1 }, timeout: isStable ? 1.0 : 5.0)
    }
    
    @MainActor @Test
    func waitExpect_Timeout() async throws {
        let isStable = isSystemTimingStable()
        
        actor Foo {
            var value = 0
            func update(value: Int) { self.value = value }
        }
        
        let foo = Foo()
        
        Task {
            try await Task.sleep(seconds: isStable ? 1.0 : 5.0)
            await foo.update(value: 1)
        }
        
        #expect(await foo.value == 0)
        
        await withKnownIssue("Wait should timeout.") {
            await wait(expect: { await foo.value == 1 }, timeout: 0.5)
        }
    }
    
    @MainActor @Test
    func waitRequire_Timeout() async throws {
        let isStable = isSystemTimingStable()
        
        actor Foo {
            var value = 0
            func update(value: Int) { self.value = value }
        }
        
        let foo = Foo()
        
        Task {
            try await Task.sleep(seconds: isStable ? 1.0 : 5.0)
            await foo.update(value: 1)
        }
        
        #expect(await foo.value == 0)
        
        await withKnownIssue("Wait should timeout.") {
            try await wait(require: { await foo.value == 1 }, timeout: 0.5)
        }
    }
}
