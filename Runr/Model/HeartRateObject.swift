//
//  HeartRateObject.swift
//  Runr
//
//  Created by Philip Sawyer on 8/26/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation

import RealmSwift

class HeartRateObject: Object {
	
	@objc dynamic var timestamp: Double = 0
	
	@objc dynamic var heartRate: Double = 0
}
