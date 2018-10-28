//
//  LocationController.swift
//  Runr
//
//  Created by Philip Sawyer on 8/26/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationControllerDelegate: class {
	func didUpdateLocations(with locations: [CLLocation])
	func didFail(with error: Error)
	func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus)
}

class LocationController: NSObject {
	
	weak var delegate: LocationControllerDelegate?
	
	internal var locationManager: CLLocationManager
	
	override init() {
		locationManager = CLLocationManager()
		
		super.init()
		
		locationManager.allowsBackgroundLocationUpdates = true
		locationManager.delegate = self
	}
	
	
	func startUpdatingLocations() {
		locationManager.startUpdatingLocation()
	}
	
	
	func stopLocationUpdates() {
		locationManager.stopUpdatingLocation()
	}
}



// MARK: - CLLocationManagerDelegate

extension LocationController: CLLocationManagerDelegate {
	
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
