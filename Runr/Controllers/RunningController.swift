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
import HealthKit

@objc enum RunType: Int {
	case outdoor
	case indoor
}

class RunningController {
	
	private var currentRun: Run?
	
	var locationController: LocationController
	
	var dataController: DataController
	
	private var timer: Timer?
	
	private var routeBuilder: HKWorkoutRouteBuilder
	
	private var healthStore: HKHealthStore
	
	
	init(locationController: LocationController, dataController: DataController) {
		self.locationController = locationController
		self.dataController = dataController
		
		healthStore = HKHealthStore()
		routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
		
		self.locationController.delegate = self
	}
	
	
	func startRun(with runType: RunType) {
		if currentRun == nil {
			// Create a new run if starting a new run. If `currentRun` is not nil,
			// then the run has been paused and just needs to be started again
			currentRun = Run()
			dataController.add(run: currentRun!)
		}
		
		startTimer()
		
		switch runType {
		case .outdoor:
			startOutdoorRun()
		case .indoor:
			startIndoorRun()
		}
	}
	
	
	func pauseRun() {
		guard let currentRun = currentRun else { return }
		debugPrint(#function)
		dataController.update(run: currentRun, endDate: Date())
		timer?.invalidate()
		switch currentRun.runType {
		case .outdoor:
			dataController.update(run: currentRun, state: .paused)
			locationController.stopLocationUpdates()
		case .indoor:
			break
		}
	}
	
	
	func endRun() {
		guard let currentRun = currentRun else { return }
		debugPrint(#function)
		dataController.update(run: currentRun, endDate: Date())
		timer?.invalidate()
		switch currentRun.runType {
		case .outdoor:
			dataController.update(run: currentRun, state: .ended)
			locationController.stopLocationUpdates()
		case .indoor:
			break
		}
		
		
		
		
		// handle saving the workout and the route to the workout
		// TODO: handle getting the workout which was saved on the apple watch, if there was any. if user is not
		// using a watch, create workout here
		let workout = HKWorkout(activityType: .running, start: currentRun.startDate, end: currentRun.endDate)
		routeBuilder.finishRoute(with: workout, metadata: [:]) { (_, _) in }
		
		
		self.currentRun = nil
	}
	
	
	
	// MARK: - Timer Functionality
	
	@objc private func timerUpdated(_ timer: Timer) {
		guard let currentRun = currentRun else { return }
		let newDuration: TimeInterval = currentRun.duration + 0.01
		dataController.update(run: currentRun, duration: newDuration)
	}
	
	
	private func startTimer() {
		timer = Timer(timeInterval: 0.01, target: self, selector: #selector(timerUpdated(_:)), userInfo: nil, repeats: true)
		RunLoop.current.add(timer!, forMode: .common)
	}
	
	
	
	// MARK: - Outdoor Run
	
	private func startOutdoorRun() {
		debugPrint(#function)
		guard let currentRun = currentRun else { return }
		dataController.update(run: currentRun, runType: .outdoor)
		dataController.update(run: currentRun, state: .running)
		
		locationController.startUpdatingLocations()
	}
	
	
	
	// MARK: - Indoor Run
	
	private func startIndoorRun() {
		guard let currentRun = currentRun else { return }
		dataController.update(run: currentRun, runType: .indoor)
		
	}
}


extension RunningController: LocationControllerDelegate {
	
	func didUpdateLocations(with locations: [CLLocation]) {
		guard let currentRun = currentRun, currentRun.state == .running else { return }
		
		debugPrint("new locations: \(locations)")
		
		locations.forEach { (cllocation) in
			guard cllocation.horizontalAccuracy >= 0, cllocation.horizontalAccuracy <= 50.0, cllocation.verticalAccuracy >= 0 else { return }
			let location = Location(cllocation: cllocation)
			dataController.update(run: currentRun, newLocations: [location])
			
			routeBuilder.insertRouteData([cllocation]) { (_, _) in }
		}
	}
	
	func didFail(with error: Error) {
		// TODO: alert the user there has been a failure
	}
	
	func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus) {
		// TODO: handle authorization status
	}
}
