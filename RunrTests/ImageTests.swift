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
	
	
	
	// MARK: - General Images Tests
	
	func testDisclosureIcon() {
		let image = UIImage(named: "DisclosureIndicator")
		XCTAssertNotNil(image)
	}
	
	func testBackArrow() {
		let image = UIImage(named: "BackArrow")
		XCTAssertNotNil(image)
	}
	
	
	
	// MARK: - Lets Run View Controller Images
	
	func testOpenGoalIcon() {
		let image = UIImage(named: "OpenGoal")
		XCTAssertNotNil(image)
	}
	
	func testTimedGoalIcon() {
		let image = UIImage(named: "TimedGoal")
		XCTAssertNotNil(image)
	}
	
	func testDistanceGoalIcon() {
		let image = UIImage(named: "DistanceGoal")
		XCTAssertNotNil(image)
	}
	
	func testCaloriesGoalIcon() {
		let image = UIImage(named: "CaloriesGoal")
		XCTAssertNotNil(image)
	}
}
