//
//  MainInterfaceController.swift
//  Watch Extension
//
//  Created by Philip Sawyer on 11/16/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import WatchKit
import HealthKit
import WatchConnectivity

class MainInterfaceController: WKInterfaceController {
	
	static let interfaceName: String = "MainInterface"
	
	let healthStore = HKHealthStore()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
		WCSession.default.delegate = self
		WCSession.default.activate()
		
		if let workoutConfiguration = context as? HKWorkoutConfiguration {
			openWorkoutInterfaceController(with: workoutConfiguration)
		}
    }
	
	
	override func didAppear() {
		super.didAppear()
		
		let typesToShare = Set([
			HKObjectType.workoutType(),
			HKObjectType.seriesType(forIdentifier: HKWorkoutRouteTypeIdentifier)!
			])
		
		let typesToRead = Set([
			HKObjectType.workoutType(),
			HKObjectType.seriesType(forIdentifier: HKWorkoutRouteTypeIdentifier)!,
			HKQuantityType.quantityType(forIdentifier: .heartRate)!,
			HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
			HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
			])
		
		healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (_, _) in
			// handle this error
		}
	}

	
	
	// MARK: - User Interaction
	
	@IBAction func didTapStartButton() {
		let workoutConfiguration = HKWorkoutConfiguration()
		workoutConfiguration.activityType = .running
		workoutConfiguration.locationType = .outdoor
		
		openWorkoutInterfaceController(with: workoutConfiguration)
	}
	
	func openWorkoutInterfaceController(with configuration: HKWorkoutConfiguration) {
		self.presentController(withName: WorkoutInterfaceController.interfaceName, context: configuration)
	}
}


extension MainInterfaceController: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		debugPrint(#function, session, activationState, String(describing: error))
	}
}
