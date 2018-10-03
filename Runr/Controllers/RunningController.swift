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
	
	private var currentRun: Run?
	
	private var locationController: LocationController?
	
	
	func startRun(with runType: RunType) {
		if currentRun == nil {
			// Create a new run if starting a new run. If `currentRun` is not nil,
			// then the run has been paused and just needs to be started again
			currentRun = Run()
		}
		
		switch runType {
		case .outdoor:
			startOutdoorRun()
		case .indoor:
			startIndoorRun()
		}
	}
	
	
	func pauseRun() {
		guard let currentRun = currentRun else { return }
		switch currentRun.runType {
		case .outdoor:
			locationController?.stopLocationUpdates()
		case .indoor:
			break
		}
	}
	
	
	func endRun() {
		guard let currentRun = currentRun else { return }
		switch currentRun.runType {
		case .outdoor:
			locationController?.stopLocationUpdates()
		case .indoor:
			break
		}
		self.currentRun = nil
	}
	
	
	
	// MARK: - Outdoor Run
	
	private func startOutdoorRun() {
		currentRun?.runType = .outdoor
		
		locationController = LocationController(delegate: self)
	}
	
	
	
	// MARK: - Indoor Run
	
	private func startIndoorRun() {
		currentRun?.runType = .indoor
		
		
	}
}


extension RunningController: LocationControllerDelegate {
	
	func didUpdateLocations(with locations: [CLLocation]) {
		guard let currentRun = currentRun, currentRun.state == .running else { return }
		
		locations.forEach {
			let location = Location(cllocation: $0)
			currentRun.locations.append(location)
		}
	}
	
	func didFail(with error: Error) {
		// TODO: alert the user there has been a failure
	}
	
	func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus) {
		// TODO: handle authorization status
	}
}
