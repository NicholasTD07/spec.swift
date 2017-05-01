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
    static var allTests = describe("spec") {
        $0.it("tests equality") {
            XCTAssertTrue(expect(1) == 1)

            // To make sure everything is working properly,
            // uncomment the line below to see the test fails.
            XCTAssertTrue(expect(1) == 2)
        }
    }
}
