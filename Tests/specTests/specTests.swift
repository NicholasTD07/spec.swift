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

class specTests: XCTestCase {
    func testExample() {
        describe("spec") {
            $0.context("tests equality") {
                $0.it("passes if values are equal") { expect(1) == 1 }
                $0.it("fails if values are not equal") { expect(1) == 2 }
            }
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
