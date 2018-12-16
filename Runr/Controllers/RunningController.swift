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
import WatchConnectivity

protocol RunningControllerDelegate: class {
	func create(run: Run)
	func startLocationUpdates()
	func stopLocationUpdates()
	func updateRunState(_ state: RunState)
	func locations(for run: Run) -> [CLLocation]
	func update(duration: TimeInterval)
}

class RunningController: NSObject {
	
	var currentRun: Run?
	
	private var timer: Timer?
	
	private var routeBuilder: HKWorkoutRouteBuilder?
	
	weak var runningControllerDelegate: RunningControllerDelegate?
	
	private var workoutEvents: [HKWorkoutEvent] = []
	
	override init() {
		
		super.init()
	}
	
	
	func startRun(with runType: RunType) {
		if currentRun == nil {
			// Create a new run if starting a new run. If `currentRun` is not nil,
			// then the run has been paused and just needs to be started again
			currentRun = Run()
		}
		
		let workoutConfiguration = HKWorkoutConfiguration()
		workoutConfiguration.activityType = .running
		workoutConfiguration.locationType = .outdoor
		
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
		runningControllerDelegate?.updateRunState(.paused)
		timer?.invalidate()
		switch currentRun.runType {
		case .outdoor:
			runningControllerDelegate?.stopLocationUpdates()
		case .indoor:
			break
		}
	}
	
	
	func endRun() {
		guard let currentRun = currentRun else { return }
		debugPrint(#function)
		runningControllerDelegate?.updateRunState(.ended)
		timer?.invalidate()
		switch currentRun.runType {
		case .outdoor:
			runningControllerDelegate?.stopLocationUpdates()
		case .indoor:
			break
		}
		
		
		let workout = HKWorkout(activityType: .running, start: currentRun.startDate,
								end: currentRun.endDate, workoutEvents: workoutEvents,
								totalEnergyBurned: nil, totalDistance: nil, metadata: nil)
		let healthStore = HKHealthStore()
		healthStore.save(workout, withCompletion: { (success, error) in
			debugPrint("success: \(success)   error: \(String(describing: error?.localizedDescription))   \(#line)")
			
			guard let locations = self.runningControllerDelegate?.locations(for: currentRun) else { return }
			let workoutBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
			workoutBuilder.insertRouteData(locations, completion: { (success, error) in
				debugPrint("success: \(success)   error: \(String(describing: error?.localizedDescription))   \(#line)")
				if let error = error {
					debugPrint("error: \(error.localizedDescription)")
				} else {
					workoutBuilder.finishRoute(with: workout, metadata: nil, completion: { (route, error) in
						debugPrint("route: \(String(describing: route))   error: \(String(describing: error?.localizedDescription))   \(#line)")
					})
				}
			})
		})
		
		self.currentRun = nil
	}
	
	
	
	// MARK: - Timer Functionality
	
	@objc private func timerUpdated(_ timer: Timer) {
		guard let currentRun = currentRun else { return }
		let newDuration: TimeInterval = currentRun.duration + 0.01
		runningControllerDelegate?.update(duration: newDuration)
	}
	
	
	private func startTimer() {
		timer = Timer(timeInterval: 0.01, target: self, selector: #selector(timerUpdated(_:)), userInfo: nil, repeats: true)
		RunLoop.current.add(timer!, forMode: .common)
	}
	
	
	
	// MARK: - Outdoor Run
	
	private func startOutdoorRun() {
		debugPrint(#function)
		guard let currentRun = currentRun else { return }
		runningControllerDelegate?.create(run: currentRun)
		runningControllerDelegate?.updateRunState(.running)
		
		runningControllerDelegate?.startLocationUpdates()
	}
	
	
	
	// MARK: - Indoor Run
	
	private func startIndoorRun() {
		debugPrint(#function)
	}
}
