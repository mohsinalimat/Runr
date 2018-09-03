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
	
	let runPortions = List<RunPortion>()
	
	@objc dynamic var distance: Double {
		return runPortions.reduce(0.0) { (result, next) -> Double in
			return result + next.distance
		}
	}
	
	@objc dynamic var elevation: Double {
		return runPortions.reduce(0.0, { (result, next) -> Double in
			return result + next.elevation
		})
	}
	
	@objc dynamic var averagePace: Double {
		return distance / (endDate.timeIntervalSince(startDate))
	}
	
	@objc dynamic var averageHeartRate: Int {
		let allHeartRates = runPortions.flatMap({ $0.heartRates }).compactMap { $0.heartRate }
		
		let sum = allHeartRates.reduce(0) { (result, next) -> Double in
			return result + next
		}
		return Int(sum) / allHeartRates.count
	}
	
	@objc dynamic var estimatedCalories: Int {
		return Int(endDate.timeIntervalSince(startDate))
	}
}
