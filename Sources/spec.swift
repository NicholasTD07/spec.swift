//
//  spec.swift
//  spec
//
//  Created by NicholasTD07 on 1/5/17.
//  Copyright © 2017 spec. All rights reserved.
//

import Foundation

public typealias Example = (name: String, closure: () -> Void)

public class Context {
    let name: String
    var examples = [Example]()

    internal init(name: String) {
        self.name = name
    }

    public func it(_ name: String, _ closure: @escaping () -> Void) {
        examples.append((name: name, closure: closure))
    }
}

public extension Context {
    public var allTests: [(String, (() -> Void))] {
        return examples.map { example in
            return ("\(name) - (example.name)", example.closure)
        }
    }
}

public struct Expectation<T> {
    fileprivate let value: T

    internal init(_ value: T) {
        self.value = value
    }
}

public func == <T: Equatable> (expectation: Expectation<T>, actual: Any) -> Bool {
    guard let actual = actual as? T else {
        return false
    }

    return expectation.value == actual
}

public func expect<T>(_ value: T) -> Expectation<T> {
    return Expectation(value)
}

public func describe(_ name: String, _ closure: (Context) -> Void) -> [(String, (() -> Void))] {
    let context = Context(name: name)

    closure(context)

    return context.allTests
}

public func describe<T>(_ name: String, _ closure: (Context) -> Void) -> [(String, ((T) -> () -> Void))] {
    let tests = describe(name, closure).map { test in
        return (test.0, { (_: T) in test.1 })
    }

    fatalError("\(tests.count)")
    return tests
}
