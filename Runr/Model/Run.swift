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

enum RunState {
	case running
	case paused
	case ended
}

class Run: Object {
	
	@objc dynamic var uuidString: String = ""
	
	@objc dynamic var runType: RunType = .outdoor
	
	@objc dynamic var title: String = ""
	
	@objc dynamic var startDate: Date = Date()
	
	@objc dynamic var endDate: Date = Date()
	
	@objc dynamic var duration: TimeInterval = 0.0
	
	var state: RunState = .running
	
	let locations = List<Location>()
	
	let heartRates = List<HeartRateObject>()
	
	@objc dynamic var distance: Double = 0.0
	
	@objc dynamic var elevation: Double {
		return locations.reduce(0.0, { (result, next) -> Double in
			return result + next.altitude
		})
	}
	
	@objc dynamic var averagePace: Double {
		return distance / duration
	}
	
	@objc dynamic var averageHeartRate: Int {
		
		let sum = heartRates.reduce(0) { (result, next) -> Double in
			return result + next.heartRate
		}
		return Int(sum) / heartRates.count
	}
	
	@objc dynamic var estimatedCalories: Int {
		// TODO: implement calorie calculations
		return Int(duration)
	}
	
	
	convenience init(uuid: UUID = UUID()) {
		self.init()
		
		self.uuidString = uuid.uuidString
	}
}
