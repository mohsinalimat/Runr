//
//  WorkoutInterfaceController.swift
//  Watch Extension
//
//  Created by Philip Sawyer on 11/12/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class WorkoutInterfaceController: WKInterfaceController {
	
	static let interfaceName: String = "WorkoutInterfaceController"

	private var healthStore: HKHealthStore
	
	private var workoutSession: HKWorkoutSession?
	
	
	override init() {
		healthStore = HKHealthStore()
		
		super.init()
	}
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		
		// Start a workout session with the configuration
		if let workoutConfiguration = context as? HKWorkoutConfiguration {
			do {
				workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
				workoutSession?.delegate = self
				
//				workoutStartDate = Date()
				
				workoutSession?.startActivity(with: Date())
			} catch {
				debugPrint("error starting workout: \(error.localizedDescription)")
			}
		}
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

	
	// MARK: - Actions
	
	@IBAction func didTapStartButton() {
		startRun()
	}
	
	@IBAction func didTapPauseButton() {
		workoutSession?.pause()
	}
	
	@IBAction func didTapEndButton() {
		workoutSession?.end()
	}
	
	
	
	// MARK: - Run functionality
	
	private func startRun() {
		let configuration = HKWorkoutConfiguration()
		configuration.activityType = .running
		configuration.locationType = .outdoor
		
		do {
			workoutSession = try HKWorkoutSession(healthStore: self.healthStore, configuration: configuration)
			
			workoutSession?.delegate = self
			workoutSession?.startActivity(with: Date())
		} catch let error as NSError {
			// Perform proper error handling here...
			fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
		}
	}
	
	
	private func queryForCalories() {
		guard let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
			fatalError("*** Unable to create the active energy burned type ***")
		}
		
		let device = HKDevice.local()
		
		let datePredicate = HKQuery.predicateForSamples(withStart: workoutSession?.startDate, end: workoutSession?.endDate, options: [])
		let devicePredicate = HKQuery.predicateForObjects(from: [device])
		let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, devicePredicate])
		
		let sortByDate = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
		
		let healthStore = self.healthStore
		
		let query = HKSampleQuery(sampleType: activeEnergyType,
								  predicate: predicate,
								  limit: Int(HKObjectQueryNoLimit),
								  sortDescriptors: [sortByDate]) { (_, returnedSamples, error) in
									
									guard let samples = returnedSamples as? [HKQuantitySample] else {
										// Handle the error here.
										print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
										return
									}
									
									// Create the workout here.
									self.createWorkout(with: samples)
		}
		
		healthStore.execute(query)
	}
	
	
	private func createWorkout(with samples: [HKQuantitySample]) {
		guard let workoutSession = workoutSession else { return }
		let energyUnit = HKUnit.kilocalorie()
		var totalActiveEnergy: Double = 0.0
		
		samples.forEach {
			totalActiveEnergy += $0.quantity.doubleValue(for: energyUnit)
		}
		
		let startDate = workoutSession.startDate ?? Date()
		let endDate = workoutSession.endDate ?? Date()
		let duration = endDate.timeIntervalSince(startDate)
		
		let totalActiveEnergyQuantity = HKQuantity(unit: energyUnit, doubleValue: totalActiveEnergy)
		
		let workout = HKWorkout(activityType: .running,
								start: startDate,
								end: endDate,
								duration: duration,
								totalEnergyBurned: totalActiveEnergyQuantity,
								totalDistance: nil,
								device: HKDevice.local(),
								metadata: [:])
		
		guard healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized else {
			print("*** the app does not have permission to save workout samples ***")
			return
		}
		
		healthStore.save(workout, withCompletion: { (success, error) -> Void in
			guard success else {
				// Add proper error handling here.
				print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
				return
			}
			
			debugPrint("healthstore save successful")
			// Associate active energy burned samples with the workout.
			self.updateSamples(for: workout, samples: samples)
		})
	}
	
	
	private func updateSamples(for workout: HKWorkout, samples: [HKQuantitySample]) {
		guard healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized else {
			print("*** the app does not have permission to save active energy burned samples ***")
			return
		}
		
		healthStore.add(samples, to: workout, completion: { (success, error) -> Void in
			guard success else {
				// Handle the error here.
				print("*** an error occurred: \(String(describing: error?.localizedDescription)) ***")
				return
			}
			
			// Provide clear feedback that the workout saved successfully here.
			debugPrint("workout saved")
		})
	}
}


extension WorkoutInterfaceController: HKWorkoutSessionDelegate {
	
	func workoutSession(_ workoutSession: HKWorkoutSession,
						didChangeTo toState: HKWorkoutSessionState,
						from fromState: HKWorkoutSessionState,
						date: Date) {
		switch toState {
		case .running:
//			if fromState == .notStarted {
//				startAccumulatingData(startDate: workoutStartDate!)
//			} else {
//				resumeAccumulatingData()
//			}
			break
		case .paused:
//			pauseAccumulatingData()
			break
		case .ended:
//			stopAccumulatingData()
//			saveWorkout()
			queryForCalories()
		default:
			break
		}
	}
	
	func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
		debugPrint(#function)
	}
}
