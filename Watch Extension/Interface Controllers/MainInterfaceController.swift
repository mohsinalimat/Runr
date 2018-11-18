//
//  MainInterfaceController.swift
//  Watch Extension
//
//  Created by Philip Sawyer on 11/16/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import WatchKit
import HealthKit


class MainInterfaceController: WKInterfaceController {
	
	static let interfaceName: String = "MainInterface"
	
	let healthStore = HKHealthStore()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
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
		
		self.presentController(withName: WorkoutInterfaceController.interfaceName, context: workoutConfiguration)
	}
}
