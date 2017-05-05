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
    internal let closure: () -> TestResult.State
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

        _ = currentGroup.popLast()
    }

    public func it(_ name: String, _ closure: @escaping () -> TestResult.State) {
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
    public var actual: T { return expression() }
}

public struct TestResult {
    let name: String
    let state: State

    public enum State {
        case passed
        case failed
        case typeMismatched // TODO: include the expected and actual types if possible
        // TODO: add a mismatching values?

        init(passed: Bool) {
            if passed {
                self = .passed
            } else {
                self = .failed
            }
        }
    }
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

        print(Report.report(resultGroups, using: .doc))

        print(resultGroups)

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
                let result = TestResult(name: test.name, state: test.closure())
                return .right(result)
            }
        }

        group.reversed().forEach { step in
            guard case let .left(context) = step else { return }

            context.afters.forEach { $0() }
        }

        return resultGroup
    }
}

// Reporting

enum Report {
    case doc
    case dot

    enum Text: CustomStringConvertible {
        case indentation(level: Int)
        case text(String)
        case color

        var description: String {
            switch self {
            case let .indentation(level): return String(repeating: "  ", count: level)
            case let .text(string): return string
            case .color: return ""
            }
        }
    }

    static func report(_ resultGroups: [ResultGroup], using style: Report) -> String {
        switch style {
        case .doc:
            return docReport(resultGroups)
        case .dot:
            return dotReport(resultGroups)
        }
    }

    private static func docReport(_ resultGroups: [ResultGroup]) -> String {
        let xs = resultGroups.map { resultGroup in
            return resultGroup.enumerated().map { (index, step) -> [Text] in
                switch step {
                case let .left(name):
                    return [.indentation(level: index), .text(name)]
                case let .right(result):
                    return [.indentation(level: index), .text(result.name)]
                }
            }
        }

        // group 0, group 1, group 2
        xs.joined().forEach {
            print($0.map { String(describing: $0) }.joined())
        }

        return ""
        /* return resultGroups.map { resultGroup -> String in */
        /*     return resultGroup.map { step -> String in */
        /*         switch step { */
        /*         case let .left(name): return name */
        /*         case let .right(result): return "\(result.name) passed: \(result.state)" */
        /*         } */
        /*     }.joined(separator: " - ") */
        /* }.joined(separator: "\n") */
    }

    private static func dotReport(_ resultGroups: [ResultGroup]) -> String {
        return ""
    }
}

// Matchers

extension Expression where T: Collection {
    public func beEmpty() -> TestResult.State {
        return .init(passed: actual.isEmpty)
    }
}

extension Expression where T: Sequence, T.Iterator.Element: Equatable {
    public func contain(_ value: T.Iterator.Element) -> TestResult.State {
        return .init(passed: actual.contains(value))
    }
}

public func == <T>(_ expression: Expression<T>, _ expected: T) -> TestResult.State
    where T: Equatable
{
    return .init(passed: expression.actual == expected)
}

public func != <T>(_ expression: Expression<T>, _ expected: T) -> TestResult.State
    where T: Equatable
{
    return .init(passed: expression.actual != expected)
}

public func == <T>(_ expression: Expression<Optional<T>>, _ expected: T) -> TestResult.State
    where T: Equatable
{
    guard let actual = expression.actual else {
        return .typeMismatched
    }

    return .init(passed: actual == expected)
}

public func != <T>(_ expression: Expression<Optional<T>>, _ expected: T) -> TestResult.State
    where T: Equatable
{
    guard let actual = expression.actual else {
        return .typeMismatched
    }

    return .init(passed: actual != expected)
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

extension TestResult: CustomDebugStringConvertible {
    public var debugDescription: String { return "\(name) \(state)" }
}
