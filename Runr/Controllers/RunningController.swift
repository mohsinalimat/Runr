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
	
	private var currentRunPortion: RunPortion?
	
	private var locationController: LocationController?
	
	
	func startRun(with runType: RunType) {
		if currentRun == nil {
			// Create a new run if starting a new run. If `currentRun` is not nil,
			// then the run has been paused and just needs to be started again
			currentRun = Run()
		}
		currentRunPortion = RunPortion()
		currentRun?.runPortions.append(currentRunPortion!)
		
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
		currentRunPortion = nil
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
		self.currentRunPortion = nil
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
		locations.forEach {
			let location = Location(cllocation: $0)
			currentRunPortion?.locations.append(location)
		}
	}
	
	func didFail(with error: Error) {
		// TODO: alert the user there has been a failure
	}
	
	func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus) {
		// TODO: handle authorization status
	}
}
