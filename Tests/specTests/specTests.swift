//
//  specTests.swift
//  spec
//
//  Created by NicholasTD07 on 1/5/17.
//  Copyright © 2017 spec. All rights reserved.
//

import Foundation
import XCTest
import spec

struct Cat {
    enum Food {
        case fish
    }
    enum Action {
        case eat(Food)
        case meow
        case sleep
    }

    var actions: [Action] = []

    private mutating func did(_ action: Action) {
        print(action)
        actions.append(action)
    }

    mutating func feed(_ food: Food) {
        did(.eat(food))
        meow()
    }

    mutating func meow() {
        did(.meow)
    }

    mutating func sleep() {
        did(.sleep)
    }
}

func testSpec() {
    describe("Cat") {
        var cat: Cat!

        $0.before { cat = Cat() }

        $0.context("when being fed") {
            $0.before { cat.feed(.fish) }
            $0.it("eats") { /* expect(cat.actions).contains(.eat(.food)) */ }
            $0.it("meows") { /* expect(cat.actions.last) == .meow */ }
        }

        $0.after { cat.sleep() }
        $0.it("did not sleep") { /* expect(cat.actions.last) != .sleep */ }
    }
}

class specTests: XCTestCase {
    func testExample() {
        testSpec()
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
