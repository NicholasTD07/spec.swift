//
//  spec.swift
//  spec
//
//  Created by NicholasTD07 on 1/5/17.
//  Copyright © 2017 spec. All rights reserved.
//

import Foundation

public class Context {
    public func it(_ name: String, _ closure: () -> Void) {
        closure()
    }
}

public struct Expectation<T> {
    private let value: T

    internal init(_ value: T) {
        self.value = value
    }
}

public func == <T>(rhs: Expectation<T>, lhs: Any) -> Bool {
    return false
}

public func expect<T>(_ value: T) -> Expectation<T> {
    return Expectation(value)
}

public func describe(_ name: String, _ closure: (Context) -> Void) {
    let context = Context()

    closure(context)
}
