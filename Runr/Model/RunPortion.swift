//
//  RunPortion.swift
//  Runr
//
//  Created by Philip Sawyer on 9/3/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation

import RealmSwift

class RunPortion: Object {
	
	@objc dynamic var startDate: Date = Date()
	
	@objc dynamic var endDate: Date = Date()
	
	@objc dynamic var distance: Double = 0.0
	
	@objc dynamic var duration: TimeInterval = 0.0
	
	@objc dynamic var elevation: Double = 0.0
	
	let locations = List<Location>()
	
	let heartRates = List<HeartRateObject>()
}
