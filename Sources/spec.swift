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
    /* let name: String */
    /* var examples = [Example]() */

    /* internal init(name: String) { */
    /*     self.name = name */
    /* } */

    public func context(_ name: String, _ closure: @escaping (Context) -> Void) {
        let context = Context() // (name: name)

        print(name)
        closure(context)
    }

    public func it(_ name: String, _ closure: @escaping () -> Void) {
        print(name)
        closure()
    }
}

public struct Expectation<T> {
    fileprivate let value: T

    internal init(_ value: T) {
        self.value = value
    }
}

public func == <T: Equatable> (expectation: Expectation<T>, actual: Any) {
    guard let actual = actual as? T else {
        return
    }

    if expectation.value == actual {
        print("passed")
    } else {
        print("failed")
    }
}

public func expect<T>(_ value: T) -> Expectation<T> {
    return Expectation(value)
}

public func describe(_ name: String, _ closure: (Context) -> Void) {
    let context = Context() // (name: name)

    print(name)
    closure(context)
}
