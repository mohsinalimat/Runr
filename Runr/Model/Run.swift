//
//  Run.swift
//  Runr
//
//  Created by Philip Sawyer on 8/25/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation
import CoreLocation

import RealmSwift

class Run: Object {
	
	@objc dynamic var runType: RunType = .outdoor
	
	@objc dynamic var startDate: Date = Date()
	
	@objc dynamic var endDate: Date = Date()
	
	@objc dynamic var averagePace: Double = 0.0
	
	@objc dynamic var distance: Double = 0.0
	
	@objc dynamic var duration: TimeInterval = 0.0
	
	@objc dynamic var elevation: Double = 0.0
	
	@objc dynamic var averageHeartRate: Int = 0
	
	@objc dynamic var estimatedCalories: Int = 0
	
	let locations = List<Location>()
	
	let heartRates = List<HeartRateObject>()
}
