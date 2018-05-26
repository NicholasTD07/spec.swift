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
    enum Action: Equatable {
        case eat(Food)
        case meow
        case sleep

        static func ==(lhs: Action, rhs: Action) -> Bool {
            switch (lhs, rhs) {
                case let (.eat(l), .eat(r)): return l == r
                case (.meow, .meow): return true
                case (.sleep, .sleep): return true
                default: return false
            }
        }
    }

    var actions: [Action] = []

    private mutating func did(_ action: Action) {
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

        $0.it("did not do anything") { expect(cat.actions) == ([] as [Cat.Action]) }
        $0.it("did not do anything (optional)") { expect(cat.actions as [Cat.Action]?) == ([] as [Cat.Action]) }

        $0.context("when being fed") {
            $0.before { cat.feed(.fish) }
            $0.it("eats") { expect(cat.actions).to.contain(.eat(.fish)) }
            $0.it("meows") { expect(cat.actions.last) == .meow }
        }

        $0.after { cat.sleep() }

        // `it` runs without any interference from previous $0.context
        $0.it("did not eat") { expect(cat.actions).to.beEmpty() }
        // `it` runs before the after closure
        $0.it("did not sleep") { expect(cat.actions).to.beEmpty() }
    }

    describe("spec") {
        $0.it("toNot") { expect([0]).toNot.beEmpty() }
        $0.it("toFail") { expect([0]).to.beEmpty().toFail() }

        $0.it("matches true") { expect(true).to.beTrue() }
        $0.it("matches false") { expect(false).toNot.beTrue() }

        $0.context("equatables") {
            $0.it("matches equatables") { expect(1) == 1 }
            $0.it("matches equatables") { expect(1) != 0 }
            $0.it("matches arrays") { expect([0] as [Int]?) == [0] }
            $0.it("matches arrays") { expect([0] as [Int]?) != [] }

            $0.context("optional - failing tests") {
                let optional: Int? = nil

                $0.it("matches equatables") { (expect(optional) == 1).toFail() }
                $0.it("matches equatables") { (expect(optional) != 0).toFail() }
                $0.it("matches arrays") { (expect(nil) == [0]).toFail() }
                $0.it("matches arrays") { (expect(nil) != [0]).toFail() }
            }
        }
    }

    describe("before and afters") {
        // BAD: should never assign values to vars outside of `before`s
        // otherwise it could get overwritten by sub-specs like in this one
        var texts: [String] = ["tada"]

        $0.context("befores and afters should get run") {
            $0.before { texts.append("tada") }
            $0.it("texts has 2 tadas") { expect(texts) == ["tada", "tada"]}
            $0.after { texts = [] }
        }

        $0.it("texts is empty if afters are run") { expect(texts).to.beEmpty() }
    }

    describe("orders") {
        var texts: [String] = []

        $0.before { texts.append("it") }
        $0.before { texts.append("should") }
        $0.it("should be in order") { texts.append("be"); return .passed }
        $0.after { texts.append("in") }
        $0.after { texts.append("order") }

        // Assumption: afters are run
        // which should be guaranteed by the "afters" spec
        $0.after { assert(texts == ["it", "should", "be", "in", "order"]) }
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
