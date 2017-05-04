//
//  spec.swift
//  spec
//
//  Created by NicholasTD07 on 1/5/17.
//  Copyright © 2017 spec. All rights reserved.
//

#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

import Foundation

enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

typealias Step = Either<Context, Test>
typealias Group = [Step]
typealias ResultStep = Either<String, TestResult>
typealias ResultGroup = [ResultStep]

public struct Test {
    internal let name: String
    internal let closure: () -> TestResult
}

public class Context {
    internal let name: String
    internal var befores = [() -> Void]()
    internal var afters = [() -> Void]()


    internal init(name: String) {
        self.name = name
    }

    public func before(_ before: @escaping () -> Void) {
        befores.append(before)
    }

    public func after(_ after: @escaping () -> Void) {
        afters.append(after)
    }

    public func context(_ name: String, _ closure: (Context) -> Void) {
        guard !currentGroup.isEmpty else {
            // Only publicly accessible way to create `Context`
            // is to call the global `describe` func
            // and that adds the created context to currentGroup
            fatalError("Impossible Error...")
        }

        let context = Context(name: name)

        currentGroup.append(.left(context))

        closure(context)
    }

    public func it(_ name: String, _ closure: @escaping () -> TestResult) {
        guard !currentGroup.isEmpty else {
            // Only publicly accessible way to create `Context`
            // is to call the global `describe` func
            // and that adds the created context to currentGroup
            fatalError("Impossible Error...")
        }

        var group = currentGroup
        let test = Test(name: name, closure: closure)

        group.append(.right(test))

        groups.append(group)
    }
}

public struct Expression<T> {
    let expression: () -> T
    /* let location: */

    public var to: Expression { return self }
}

public struct TestResult {
}

public func describe(_ name: String, _ closure: @escaping (Context) -> Void) {
    let context = Context(name: name)

    currentGroup = [.left(context)]

    closure(context)
}

public func expect<T>(_ expression: @autoclosure @escaping () -> T) -> Expression<T> {
    return Expression(expression: expression)
}

private var currentGroup: Group = {
    atexit {
        print(groups)
        execute(groups)
    }
    return []
}()
private var groups: [Group] = []
private var resultGroups: [ResultGroup] = []

private func execute(_ groups: [Group]) {
    resultGroups = groups.map { group -> ResultGroup in
        let resultGroup =  group.map { step -> ResultStep in
            switch step {
            case let .left(context):
                context.befores.forEach { $0() }
                return .left(context.name)
            case let .right(test):
                return .right(test.closure())
            }
        }

        group.reversed().forEach { step in
            guard case let .left(context) = step else { return }

            context.afters.forEach { $0() }
        }

        return resultGroup
    }
}

// Matchers

extension Expression where T: Sequence {
    public func contain(_ value: T.Iterator.Element) -> TestResult {
        return TestResult()
    }
}

public func != <T>(_ expression: Expression<T>, _ expected: T) -> TestResult{
        return TestResult()
}

public func == <T>(_ expression: Expression<T>, _ expected: T) -> TestResult{
        return TestResult()
}

// CustomDebugStringConvertible

extension Either: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case let .left(value):
            return String(describing: value)
        case let .right(value):
            return String(describing: value)
        }
    }
}

extension Context: CustomDebugStringConvertible {
    public var debugDescription: String { return name }
}

extension Test: CustomDebugStringConvertible {
    public var debugDescription: String { return name }
}
