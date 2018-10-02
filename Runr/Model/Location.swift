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
	
	@objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: -1, longitude: -1)
	
	@objc dynamic var altitude: CLLocationDistance = 0
	
	@objc dynamic var floor: CLFloor?
	
	@objc dynamic var horizontalAccuracy: CLLocationAccuracy = 0.0
	
	@objc dynamic var verticalAccuracy: CLLocationAccuracy = 0.0
	
	@objc dynamic var timestamp: Date = Date()
}
