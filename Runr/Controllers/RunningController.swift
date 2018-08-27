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
	
	func startRun(with runType: RunType) {
		switch runType {
		case .outdoor:
			currentRun.runType = .outdoor
			
		case .indoor:
			currentRun.runType = .indoor
			
		}
	}
	
	
	func pauseRun() {
		
	}
	
	
	func endRun() {
		
	}
	
	
	// MARK: - Outdoor Run
	
	private func startOutdoorRun() {
		currentRun.runType = .outdoor
		
		
	}
	
	
	
	// MARK: - Indoor Run
	
	private func startIndoorRun() {
		currentRun.runType = .indoor
		
		
	}
}


extension RunningController: LocationDelegate {
	
	func didUpdateLocations(with locations: [CLLocation]) {
		
	}
	
	func didFail(with error: Error) {
		
	}
	
	func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus) {
		
	}
}
