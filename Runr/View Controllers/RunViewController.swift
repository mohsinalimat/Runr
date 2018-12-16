//
//  RunViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 8/25/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit

class RunViewController: UIViewController {
	
	@IBOutlet weak var runningView: UIView!
	
	static func build(runrController: RunrController) -> RunViewController {
		let storyboard = UIStoryboard(name: className, bundle: nil)
		let viewController = storyboard.instantiateInitialViewController() as! RunViewController
		viewController.runrController = runrController
		return viewController
	}
	
	// MARK: - Variables
	
	@objc dynamic private var runrController: RunrController!
	
	private lazy var runningViewController: RunningViewController = {
		let viewController = RunningViewController.build(runningController: runrController.runningController)
		return viewController
	}()
	
	
	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		runningView.addSubview(runningViewController.view)
		runningViewController.view.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			runningViewController.view.topAnchor.constraint(equalTo: runningView.topAnchor),
			runningViewController.view.leadingAnchor.constraint(equalTo: runningView.leadingAnchor),
			runningViewController.view.trailingAnchor.constraint(equalTo: runningView.trailingAnchor),
			runningViewController.view.bottomAnchor.constraint(equalTo: runningView.bottomAnchor),
		])
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let locationStatus = CLLocationManager.authorizationStatus()
		if locationStatus != .authorizedWhenInUse || locationStatus != .authorizedAlways {
			self.runrController.locationController.locationManager.requestWhenInUseAuthorization()
		}
		
		self.authorizeHealthKit()
	}
	
	
	// TODO: move me elsewhere
	private func authorizeHealthKit() {
		if HKHealthStore.isHealthDataAvailable() {
			let healthKitStore = HKHealthStore()
			
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
			
			// TODO: handle what to do in the event the user declines
			healthKitStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
				debugPrint("healthkit success: \(success), error: \(String(describing: error?.localizedDescription))")
			}
		}
	}
	
	
	// TODO: remove me and move to RunManagerViewController
	
	@IBAction func startRun(_ sender: UIButton) {
		runrController.runningController.startRun(with: .outdoor)
	}
	
	
	@IBAction func pauseRun(_ sender: UIButton) {
		runrController.runningController.pauseRun()
	}
	
	
	@IBAction func endRun(_ sender: UIButton) {
		runrController.runningController.endRun()
	}
}
