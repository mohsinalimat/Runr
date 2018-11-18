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
	
	static let interfaceName: String = "WorkoutInterface"
	
	@IBOutlet weak var elapsedTimer: WKInterfaceTimer!
	
	@IBOutlet weak var heartRateLabel: WKInterfaceLabel!
	
	@IBOutlet weak var caloriesLabel: WKInterfaceLabel!
	
	@IBOutlet weak var distanceLabel: WKInterfaceLabel!
	
	@IBOutlet weak var pauseResumeButton: WKInterfaceButton!

	private var healthStore: HKHealthStore
	
	private var workoutSession: HKWorkoutSession!
	private var builder: HKLiveWorkoutBuilder!
	private var routeBuilder: HKWorkoutRouteBuilder
	
	private var locationController: LocationController
	
	
	override init() {
		healthStore = HKHealthStore()
		locationController = LocationController()
		routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
		
		super.init()
		
		locationController.delegate = self
	}
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
		
		// Start a workout session with the configuration
		if let workoutConfiguration = context as? HKWorkoutConfiguration {
			do {
				workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
				builder = workoutSession.associatedWorkoutBuilder()
			} catch {
				debugPrint("error starting workout: \(error.localizedDescription)")
				dismiss()
				return
			}
			
			workoutSession.delegate = self
			builder.delegate = self
			builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: workoutConfiguration)
			
			workoutSession.startActivity(with: nil)
			builder.beginCollection(withStart: Date()) { (_, _) in
				self.setDurationTimerDate()
				DispatchQueue.main.async {
					self.locationController.startUpdatingLocations()
				}
			}
		}
    }
	
	
	
	// MARK: - Actions
	
	@IBAction func didTapPauseButton() {
		if workoutSession.state == .running {
			workoutSession?.pause()
			DispatchQueue.main.async {
				self.locationController.stopLocationUpdates()
			}
		} else {
			workoutSession.resume()
			DispatchQueue.main.async {
				self.locationController.startUpdatingLocations()
			}
		}
	}
	
	@IBAction func didTapEndButton() {
		workoutSession?.end()
		DispatchQueue.main.async {
			self.locationController.stopLocationUpdates()
		}
		builder.endCollection(withEnd: Date()) { (_, _) in
			self.builder.finishWorkout(completion: { (workout, _) in
				if let workout = workout {
					self.routeBuilder.finishRoute(with: workout, metadata: nil, completion: { (_, error) in
						if let error = error {
							debugPrint(#file, #function, error.localizedDescription)
						}
					
						DispatchQueue.main.async {
							self.dismiss()
						}
					})
				}
			})
		}
	}
	
	
	
	// MARK: - UI Functionality
	
	private func setDurationTimerDate() {
		let timerDate = Date(timeInterval: -builder.elapsedTime, since: Date())
		let sessionState = workoutSession.state
		
		DispatchQueue.main.async {
			self.elapsedTimer.setDate(timerDate)
			if sessionState == .running {
				self.elapsedTimer.stop()
			} else {
				self.elapsedTimer.start()
			}
		}
	}
}



// MARK: - HKLiveWorkoutBuilderDelegate

extension WorkoutInterfaceController: HKLiveWorkoutBuilderDelegate {
	
	func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
		setDurationTimerDate()
	}
	
	func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
		collectedTypes.forEach {
			guard
				let quantityType = $0 as? HKQuantityType,
				let statistics = workoutBuilder.statistics(for: quantityType)
			 else { return }
			
			switch quantityType.identifier {
			case HKQuantityTypeIdentifier.heartRate.rawValue:
				let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
				if let bpm = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) {
					heartRateLabel.setText("\(bpm) bpm")
				}
			case HKQuantityTypeIdentifier.activeEnergyBurned.rawValue:
				let largeCalorieUnit = HKUnit.largeCalorie()
				if let calories = statistics.sumQuantity()?.doubleValue(for: largeCalorieUnit) {
					let measurement = Measurement(value: calories, unit: UnitEnergy.calories)
					let formatter = MeasurementFormatter()
					formatter.numberFormatter.maximumFractionDigits = 1
					formatter.unitOptions = [.providedUnit]
					
					caloriesLabel.setText(formatter.string(from: measurement))
				}
			case HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue:
				let mileUnit = HKUnit.mile()
				if let miles = statistics.sumQuantity()?.doubleValue(for: mileUnit) {
					let measurement = Measurement(value: miles, unit: UnitLength.miles)
					let formatter = MeasurementFormatter()
					formatter.numberFormatter.maximumFractionDigits = 2
					
					distanceLabel.setText(formatter.string(from: measurement))
				}
			default:
				break
			}
		}
	}
}



// MARK: - HKWorkoutSessionDelegate

extension WorkoutInterfaceController: HKWorkoutSessionDelegate {
	
	func workoutSession(_ workoutSession: HKWorkoutSession,
						didChangeTo toState: HKWorkoutSessionState,
						from fromState: HKWorkoutSessionState,
						date: Date) {
		debugPrint(#function)
	}
	
	func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
		debugPrint(#function, error.localizedDescription)
	}
}



// MARK: - LocationControllerDelegate

extension WorkoutInterfaceController: LocationControllerDelegate {
	
	func didUpdateLocations(with locations: [CLLocation]) {
		debugPrint("locations: \(locations)")
		routeBuilder.insertRouteData(locations) { (success, error) in
			if !success, let error = error {
				debugPrint(#file, #function, #line, error.localizedDescription)
			}
		}
	}
	
	func didFail(with error: Error) {
		debugPrint(#file, #function, #line, error.localizedDescription)
	}
	
	func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus) {
		debugPrint(#file, #function, #line, status)
	}
}
