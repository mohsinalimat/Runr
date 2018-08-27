//
//  LocationController.swift
//  Runr
//
//  Created by Philip Sawyer on 8/26/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationDelegate: class {
	func didUpdateLocations(with locations: [CLLocation])
	func didFail(with error: Error)
	func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus)
}

class LocationController: NSObject, CLLocationManagerDelegate {
	
	weak var delegate: LocationDelegate?
	
	init(with delegate: LocationDelegate) {
		self.delegate = delegate
		super.init()
	}
	
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		delegate?.didUpdateLocations(with: locations)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		delegate?.didFail(with: error)
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		delegate?.didChangeAuthoriztionStatus(status)
	}
}
