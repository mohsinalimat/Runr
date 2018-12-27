//
//  MKCoordinateRegion+Extensions.swift
//  Runr
//
//  Created by Philip Sawyer on 12/27/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation
import MapKit

/// Modified code from https://gist.github.com/robmooney/923301
extension MKCoordinateRegion {
	
	init(coordinates: [CLLocationCoordinate2D]) {
		var minLatitude: CLLocationDegrees = 90.0
		var maxLatitude: CLLocationDegrees = -90.0
		var minLongitude: CLLocationDegrees = 180.0
		var maxLongitude: CLLocationDegrees = -180.0
		
		coordinates.forEach { (coordinate) in
			let latitude = Double(coordinate.latitude)
			let longitude = Double(coordinate.longitude)
			if latitude < minLatitude {
				minLatitude = latitude
			}
			if longitude < minLongitude {
				minLongitude = longitude
			}
			if latitude > maxLatitude {
				maxLatitude = latitude
			}
			if longitude > maxLongitude {
				maxLongitude = longitude
			}
		}
		
		let span = MKCoordinateSpan(latitudeDelta: maxLatitude - minLatitude, longitudeDelta: maxLongitude - minLongitude)
		let center = CLLocationCoordinate2DMake((maxLatitude - span.latitudeDelta / 2), maxLongitude - span.longitudeDelta / 2)
		self.init(center: center, span: span)
	}
	
}
