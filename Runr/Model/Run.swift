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
	
	@objc dynamic var title: String?
	
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
		guard heartRates.count > 0 else { return -1 }
		let sum = heartRates.reduce(0) { (result, next) -> Double in
			return result + next.heartRate
		}
		return Int(sum) / heartRates.count
	}
	
	@objc dynamic var estimatedCalories: Int {
		// TODO: implement calorie calculations
		return Int(duration)
	}
	
	
	convenience init(uuid: UUID) {
		self.init()
		
		self.uuidString = uuid.uuidString
	}
	
	
	override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
		switch key {
		case #keyPath(Run.averagePace):
			return [#keyPath(Run.distance), #keyPath(Run.duration)]
		default:
			return super.keyPathsForValuesAffectingValue(forKey: key)
		}
	}
}


extension Run {
	
	/// Returns the title if this run has one else returns a descriptive string representing the day and time of day
	var displayTitle: String {
		if let title = title {
			return title
		} else {
			return startDate.dayPlusTimeOfDay + " Run"
		}
	}
}
