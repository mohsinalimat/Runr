//
//  Coordinate.swift
//  Runr
//
//  Created by Philip Sawyer on 10/8/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation

import RealmSwift

class Coordinate: Object {
	
	public var latitude: Double = 0
	public var longitude: Double = 0
	
	convenience init(latitude: Double, longitude: Double) {
		self.init()
		self.latitude = latitude
		self.longitude = longitude
	}
}
