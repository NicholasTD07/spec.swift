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

private extension Array where Element == ResultGroup {
    var testsFailed: Bool {
        let firstFailed = first { group in
            guard let last = group.last else { return false }
            guard case let .right(result) = last else { return false }

            return result.failed
        }

        return firstFailed != nil
    }
}

internal class Global {
    internal static let shared = Global()

    private var currentGroup: Group = []
    private var groups: [Group] = []

    private init() {
        atexit {
            let results = execute(Global.shared.groups)
            let report = Report(groups: results)

            report.report(style: .dot)

            if results.testsFailed {
                exit(1)
            } else {
                exit(0)
            }
        }
    }

    internal func addGroup(with context: Context) {
        currentGroup = [.left(context)]

        context.closure(context)
    }

    internal func add(context: Context) {
        guard !currentGroup.isEmpty else {
            // TODO: update comments... OR BETTER NAMING FTW!
            // Only publicly accessible way to create `Context`
            // is to call the global `describe` func
            // and that adds the created context to currentGroup
            fatalError("Impossible Error...")
        }
        currentGroup.append(.left(context))

        context.closure(context)

        _ = currentGroup.popLast()
    }

    internal func add(test: Test) {
        guard !currentGroup.isEmpty else {
            // TODO: update comments... OR BETTER NAMING FTW!
            // Only publicly accessible way to create `Context`
            // is to call the global `describe` func
            // and that adds the created context to currentGroup
            fatalError("Impossible Error...")
        }
        var group = currentGroup

        group.append(.right(test))

        groups.append(group)
    }
}

private func execute(_ groups: [Group]) -> [ResultGroup] {
    return groups.map { group -> ResultGroup in
        let resultGroup =  group.map { step -> ResultStep in
            switch step {
            case let .left(context):
                context.befores.forEach { $0() }
                return .left(context.description)
            case let .right(test):
                return .right(
                    TestResult(
                        state: test.closure(),
                        description: test.description,
                        location: test.location
                    )
                )
            }
        }

        group.reversed().forEach { step in
            guard case let .left(context) = step else { return }

            context.afters.forEach { $0() }
        }

        return resultGroup
    }
}
