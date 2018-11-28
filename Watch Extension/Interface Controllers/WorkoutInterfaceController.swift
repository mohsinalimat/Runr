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
import WatchConnectivity


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
	
	private let runUUID = UUID()
	
	
	override init() {
		healthStore = HKHealthStore()
		locationController = LocationController()
		routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
		
		super.init()
		
		locationController.delegate = self
		
		WCSession.default.delegate = self
		WCSession.default.activate()
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
			
			workoutSession.startActivity(with: Date())
			
			self.locationController.startUpdatingLocations()
			
			builder.beginCollection(withStart: Date()) { (_, _) in
				self.setDurationTimerDate()
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
		
		DispatchQueue.main.async {
			self.locationController.stopLocationUpdates()
		}
		
		let endModel = EndModel(runUUID: self.runUUID, endTime: Date())
		self.sendData(with: endModel)
		
		workoutSession.end()
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
				} else {
					DispatchQueue.main.async {
						self.dismiss()
					}
				}
			})
		}
	}
	
	
	
	// MARK: - UI Functionality
	
	private func setDurationTimerDate() {
		let timerDate = Date(timeInterval: -self.builder.elapsedTime, since: Date())
		DispatchQueue.main.async {
			self.elapsedTimer.setDate(timerDate)
		}
		
		let sessionState = self.workoutSession.state
		DispatchQueue.main.async {
			sessionState == .running ? self.elapsedTimer.start() : self.elapsedTimer.stop()
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
					let heartRateModel = HeartRateModel(runUUID: self.runUUID, heartRate: bpm, timeStamp: Date())
					self.sendData(with: heartRateModel)
				}
			case HKQuantityTypeIdentifier.activeEnergyBurned.rawValue:
				let largeCalorieUnit = HKUnit.largeCalorie()
				if let calories = statistics.sumQuantity()?.doubleValue(for: largeCalorieUnit) {
					let measurement = Measurement(value: calories, unit: UnitEnergy.calories)
					let formatter = MeasurementFormatter()
					formatter.numberFormatter.maximumFractionDigits = 1
					formatter.unitOptions = [.providedUnit]
					
					caloriesLabel.setText(formatter.string(from: measurement))
					
					let calorieModel = ActiveEnergyModel(runUUID: self.runUUID, calorieCount: calories)
					self.sendData(with: calorieModel)
				}
			case HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue:
				let mileUnit = HKUnit.mile()
				if let miles = statistics.sumQuantity()?.doubleValue(for: mileUnit) {
					let measurement = Measurement(value: miles, unit: UnitLength.miles)
					let formatter = MeasurementFormatter()
					formatter.numberFormatter.maximumFractionDigits = 2
					
					distanceLabel.setText(formatter.string(from: measurement))
					
					let distanceModel = DistanceModel(runUUID: self.runUUID, distance: miles)
					self.sendData(with: distanceModel)
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
		if fromState == .notStarted, toState == .running {
			// starting
			let runType: RunType = workoutSession.workoutConfiguration.locationType == .outdoor ? .outdoor : .indoor
			let startModel = StartModel(runUUID: self.runUUID, startTime: date, runType: runType)
			self.sendData(with: startModel)
		} else if toState == .paused {
			// paused
			let pausedModel = PauseModel(runUUID: self.runUUID, pauseTime: date)
			self.sendData(with: pausedModel)
		} else if fromState == .paused, toState == .running {
			// resume
			let resumeModel = ResumeModel(runUUID: self.runUUID, resumeTime: date)
			self.sendData(with: resumeModel)
		}
	}
	
	func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
		debugPrint(#function, error.localizedDescription)
	}
}



// MARK: - LocationControllerDelegate

extension WorkoutInterfaceController: LocationControllerDelegate {
	
	func didUpdateLocations(with locations: [CLLocation]) {
		
		let filteredLocations = locations.filter({ $0.horizontalAccuracy >= 0 && $0.horizontalAccuracy <= 50.0 && $0.verticalAccuracy >= 0 })
		
		guard filteredLocations.count > 0 else {
			debugPrint("no locations")
			return
		}
		
		routeBuilder.insertRouteData(filteredLocations) { (success, error) in
			if !success, let error = error {
				debugPrint(#file, #function, #line, error.localizedDescription)
			}
		}
		
		filteredLocations.forEach {
			let locationModel = LocationModel(runUUID: self.runUUID, latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude,
											  altitude: $0.altitude, floor: $0.floor?.level ?? 0, horizontalAccuracy: $0.horizontalAccuracy,
											  verticalAccuracy: $0.verticalAccuracy, speed: $0.speed, timeStamp: $0.timestamp)
			self.sendData(with: locationModel)
		}
	}
	
	func didFail(with error: Error) {
		debugPrint(#file, #function, #line, error.localizedDescription)
	}
	
	func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus) {
		debugPrint(#file, #function, #line, status)
	}
}


extension WorkoutInterfaceController: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		debugPrint(#function, session, activationState, String(describing: error))
	}
}



extension WorkoutInterfaceController {
	
	fileprivate func sendData(with model: ConnectivityModel) {
		guard let data = model.data else { return }
		WCSession.default.transferUserInfo([
			ConnectivityController.updateTypeKey: model.updateType.rawValue,
			ConnectivityController.userInfoDataKey: data
			])
	}
}
