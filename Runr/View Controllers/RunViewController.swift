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
import MapKit

import SnapKit

class RunViewController: UIViewController {
		
	static func build(runrController: RunrController, cacheController: CacheController) -> RunViewController {
		let viewController = RunViewController()
		viewController.runrController = runrController
		viewController.cacheController = cacheController
		return viewController
	}
	
	
	
	// MARK: - UI Variables
	
	private lazy var mapView: MKMapView = {
		let mapView = MKMapView()
		mapView.showsUserLocation = true
		return mapView
	}()
	
	private lazy var letsRunButton: UIButton = {
		let button = UIButton(type: UIButton.ButtonType.system)
		button.setTitle("Let's Run", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		button.backgroundColor = UIColor.runrGreen
		button.layer.cornerRadius = 10.0
		button.addTarget(self, action: #selector(startStopRun(_:)), for: .touchUpInside)
		return button
	}()
	
	private lazy var runningNavigationController: UINavigationController = {
		let navigationController = UINavigationController(rootViewController: runningViewController)
		let font = UIFont.systemFont(ofSize: 16, weight: .bold)
		navigationController.navigationBar.titleTextAttributes = [
			NSAttributedString.Key.font: font,
			NSAttributedString.Key.foregroundColor: UIColor.runrGray
		]
		navigationController.navigationBar.barTintColor = UIColor.white
		navigationController.navigationBar.backIndicatorImage = UIImage.backArrow
		navigationController.view.layer.cornerRadius = 25
		navigationController.view.layer.masksToBounds = true
		return navigationController
	}()
	
	private lazy var runningViewController: RunningViewController = {
		let viewController = RunningViewController.build(runrController: runrController, cacheController: self.cacheController)
		return viewController
	}()
	
	
	// MARK: - Variables
	
	@objc dynamic private var runrController: RunrController!
	
	private var cacheController: CacheController!
	
	
	// MARK: - Lifecycle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "RUNR"
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let locationStatus = CLLocationManager.authorizationStatus()
		if locationStatus != .authorizedWhenInUse || locationStatus != .authorizedAlways {
			self.runrController.locationController.locationManager.requestWhenInUseAuthorization()
		}
		
		self.authorizeHealthKit()
	}
	
	override func loadView() {
		view = UIView()
		
		[mapView, letsRunButton, runningNavigationController.view].forEach {
			view.addSubview($0)
		}
		
		mapView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		letsRunButton.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.centerY)
			make.leading.equalTo(view.snp.leading).offset(20)
			make.trailing.equalTo(view.snp.trailing).offset(-20)
			make.height.equalTo(45)
		}
		
		runningNavigationController.view.snp.makeConstraints { (make) in
			make.top.equalTo(letsRunButton.snp.bottom).offset(20)
			make.leading.equalTo(letsRunButton.snp.leading)
			make.trailing.equalTo(letsRunButton.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
		}
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
	
	
	var isRunning: Bool = false
	
	@objc func startStopRun(_ sender: UIButton) {
		debugPrint(#function, isRunning)
		if isRunning {
			runrController.runningController.endRun()
			isRunning = false
		} else {
			runrController.runningController.startRun(with: .outdoor)
			isRunning = true
		}
	}
	
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
