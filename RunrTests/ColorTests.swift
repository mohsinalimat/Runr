//
//  ColorTests.swift
//  RunrTests
//
//  Created by Philip Sawyer on 12/26/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import XCTest

/// The importance of this suite of tests is to ensure that no colors are deleted by accident
class ColorTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testRunrGreen() {
		let color = UIColor(named: "RunrGreen")
		XCTAssertNotNil(color)
	}
	
	func testSecondaryTextColor() {
		let color = UIColor(named: "SecondaryTextColor")
		XCTAssertNotNil(color)
	}
	
	func testRunrGrayColor() {
		let color = UIColor(named: "RunrGray")
		XCTAssertNotNil(color)
	}
}
