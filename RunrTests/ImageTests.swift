//
//  ImageTests.swift
//  RunrTests
//
//  Created by Philip Sawyer on 12/26/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import XCTest

class ImageTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testDisclosureIcon() {
		let image = UIImage(named: "DisclosureIndicator")
		XCTAssertNotNil(image)
	}
	
	func testBackArrow() {
		let image = UIImage(named: "BackArrow")
		XCTAssertNotNil(image)
	}
}
