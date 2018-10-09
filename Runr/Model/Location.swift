//
//  Location.swift
//  Runr
//
//  Created by Philip Sawyer on 8/25/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation
import CoreLocation

import RealmSwift

class Location: Object {
	
	@objc dynamic var coordinate: Coordinate? = Coordinate(latitude: 0, longitude: 0)
	
	@objc dynamic var altitude: CLLocationDistance = 0
	
	@objc dynamic var floor: Int = 0
	
	@objc dynamic var horizontalAccuracy: CLLocationAccuracy = 0.0
	
	@objc dynamic var verticalAccuracy: CLLocationAccuracy = 0.0
	
	@objc dynamic var timestamp: Date = Date()
	
	
	convenience init(cllocation: CLLocation) {
		self.init()
		self.coordinate = Coordinate(latitude: cllocation.coordinate.latitude, longitude: cllocation.coordinate.longitude)
		self.altitude = cllocation.altitude
		self.floor = cllocation.floor?.level ?? 0
		self.horizontalAccuracy = cllocation.horizontalAccuracy
		self.verticalAccuracy = cllocation.verticalAccuracy
		self.timestamp = cllocation.timestamp
	}
}
