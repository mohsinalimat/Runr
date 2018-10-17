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
	
	// MARK: - Variables
	
	private var dataController: DataController
	
	private var runningController: RunningController
	
	private var locationController: LocationController
	
	private lazy var runManagerViewController: RunManagerViewController = {
		let viewController = RunManagerViewController.build(dataController: dataController,
															runningController: runningController)
		return viewController
	}()
	
	
	// MARK: - Lifecycle Methods
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		self.dataController = DataController()
		self.locationController = LocationController()
		self.runningController = RunningController(
			locationController: self.locationController,
			dataController: self.dataController)
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		self.dataController = DataController()
		self.locationController = LocationController()
		self.runningController = RunningController(
			locationController: self.locationController,
			dataController: self.dataController)
		
		super.init(coder: aDecoder)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let locationStatus = CLLocationManager.authorizationStatus()
		if locationStatus != .authorizedWhenInUse || locationStatus != .authorizedAlways {
			self.locationController.locationManager.requestWhenInUseAuthorization()
		}
		
		self.authorizeHealthKit()
	}
	
	
	// TODO: move me elsewhere
	private func authorizeHealthKit() {
		if HKHealthStore.isHealthDataAvailable() {
			let healthKitStore = HKHealthStore()
			
			let recordsToWrite = Set([
				HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
				HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
				HKObjectType.quantityType(forIdentifier: .heartRate)!
				])
			
			// TODO: handle what to do in the event the user declines
			healthKitStore.requestAuthorization(toShare: recordsToWrite, read: nil) { (success, error) in
				debugPrint("healthkit success: \(success), error: \(String(describing: error?.localizedDescription))")
			}
		}
	}
	
	
	// TODO: remove me and move to RunManagerViewController
	
	@IBAction func startRun(_ sender: UIButton) {
		runningController.startRun(with: .outdoor)
	}
	
	
	@IBAction func pauseRun(_ sender: UIButton) {
		runningController.pauseRun()
	}
	
	
	@IBAction func endRun(_ sender: UIButton) {
		runningController.endRun()
	}
}
