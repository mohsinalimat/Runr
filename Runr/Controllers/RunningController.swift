//
//  RunningController.swift
//  Runr
//
//  Created by Philip Sawyer on 8/25/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation
import CoreLocation
import CoreMotion

@objc enum RunType: Int {
	case outdoor
	case indoor
}

class RunningController {
	
	private var currentRun: Run = Run()
	
	
	private var locationController: LocationController?
	
	
	func startRun(with runType: RunType) {
		switch runType {
		case .outdoor:
			startOutdoorRun()
		case .indoor:
			startIndoorRun()
		}
	}
	
	
	func pauseRun() {
		switch currentRun.runType {
		case .outdoor:
			locationController?.stopLocationUpdates()
		case .indoor:
			break
		}
	}
	
	
	func endRun() {
		switch currentRun.runType {
		case .outdoor:
			locationController?.stopLocationUpdates()
		case .indoor:
			break
		}
	}
	
	
	
	// MARK: - Outdoor Run
	
	private func startOutdoorRun() {
		currentRun.runType = .outdoor
		
		locationController = LocationController(delegate: self)
	}
	
	
	
	// MARK: - Indoor Run
	
	private func startIndoorRun() {
		currentRun.runType = .indoor
		
		
	}
}


extension RunningController: LocationControllerDelegate {
	
	func didUpdateLocations(with locations: [CLLocation]) {
		
	}
	
	func didFail(with error: Error) {
		
	}
	
	func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus) {
		
	}
}
