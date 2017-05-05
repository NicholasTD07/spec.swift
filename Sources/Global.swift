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

var currentGroup: Group = {
    atexit {
        print(groups)
        execute(groups)
        print(resultGroups)
    }
    return []
}()
var groups: [Group] = []
var resultGroups: [ResultGroup] = []

func execute(_ groups: [Group]) {
    resultGroups = groups.map { group -> ResultGroup in
        let resultGroup =  group.map { step -> ResultStep in
            switch step {
            case let .left(context):
                context.befores.forEach { $0() }
                return .left(context.description)
            case let .right(test):
                let result = TestResult(description: test.description, state: test.closure())
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
