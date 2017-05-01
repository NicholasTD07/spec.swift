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
            $0.it("tests equality") {
                XCTAssertTrue(expect(1) == 1)
                /* XCTAssertTrue(expect(1) == 2) */
            }
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
