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

enum ViewType {
	case normal
	case letsRun
	case running
}

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
		button.addTarget(self, action: #selector(letsRunAction(_:)), for: .touchUpInside)
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
		navigationController.view.layer.cornerRadius = 25
		navigationController.view.layer.masksToBounds = true
		
		navigationController.navigationBar.backIndicatorImage = UIImage.backArrow
		navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage.backArrow
		
		return navigationController
	}()
	
	private lazy var runningViewController: RunningViewController = {
		let viewController = RunningViewController.build(runrController: runrController, cacheController: self.cacheController)
		return viewController
	}()
	
	private lazy var letsRunViewController: LetsRunViewController = {
		let viewController = LetsRunViewController.build(delegate: self)
		return viewController
	}()
	
	
	// MARK: - Variables
	
	@objc dynamic private var runrController: RunrController!
	
	private var cacheController: CacheController!
	
	private var viewType: ViewType = .normal {
		didSet {
			guard viewType != oldValue else { return }
			updateView(from: oldValue, to: viewType)
		}
	}
	
	
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
			topConstraint = make.top.equalTo(letsRunButton.snp.bottom).offset(20).constraint
			leadingConstraint = make.leading.equalTo(letsRunButton.snp.leading).constraint
			trailingConstraint = make.trailing.equalTo(letsRunButton.snp.trailing).constraint
			bottomConstraint = make.bottom.equalTo(view.snp.bottom).constraint
		}
	}
	
	
	var topConstraint: Constraint?
	var leadingConstraint: Constraint?
	var trailingConstraint: Constraint?
	var bottomConstraint: Constraint?
	
	
	
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
	
	
	@objc private func letsRunAction(_ sender: UIButton) {
		self.viewType = .letsRun
	}
	
	
	
	// MARK: - UI moving
	
	private func updateView(from oldViewType: ViewType, to newViewType: ViewType) {
		if oldViewType == .normal, newViewType == .letsRun {
			
			UIView.animate(withDuration: 0.3, animations: {
				// perform animations
				self.bottomConstraint?.update(offset: self.view.bounds.height)
				self.topConstraint?.update(offset: self.view.bounds.height)
				self.letsRunButton.isHidden = true
				self.view.layoutIfNeeded()
			}, completion: { _ in
				// completion
				self.runningNavigationController.view.snp.removeConstraints()
				self.runningNavigationController.view.removeFromSuperview()
				
				self.setupLetsRunViewConstraints()
				self.view.layoutIfNeeded()
				
				UIView.animate(withDuration: 0.3, animations: {
					// perform animations
					self.bottomConstraint?.update(offset: 0)
					self.view.layoutIfNeeded()
				})
			})
		} else if oldViewType == .letsRun, newViewType == .normal {
			
			UIView.animate(withDuration: 0.3, animations: {
				// perform animations
				self.bottomConstraint?.update(offset: self.view.bounds.height)
				self.topConstraint?.update(offset: self.view.bounds.height)
				self.view.layoutIfNeeded()
			}, completion: { (_) in
				// completion
				self.letsRunViewController.view.snp.removeConstraints()
				self.letsRunViewController.view.removeFromSuperview()
				
				self.setupRunningNavigationControllerConstraints()
				self.view.layoutIfNeeded()
				
				UIView.animate(withDuration: 0.3, animations: {
					self.bottomConstraint?.update(offset: 0)
					self.topConstraint?.update(offset: 20)
					self.letsRunButton.isHidden = false
					self.view.layoutIfNeeded()
				})
			})
		}
	}
	
	private func setupLetsRunViewConstraints() {
		self.view.addSubview(letsRunViewController.view)
		letsRunViewController.view.snp.makeConstraints { (make) in
			leadingConstraint = make.leading.equalTo(letsRunButton.snp.leading).constraint
			trailingConstraint = make.trailing.equalTo(letsRunButton.snp.trailing).constraint
			bottomConstraint = make.bottom.equalTo(view.snp.bottom).offset(self.view.bounds.height).constraint
		}
	}
	
	private func setupRunningNavigationControllerConstraints() {
		self.view.addSubview(runningNavigationController.view)
		runningNavigationController.view.snp.makeConstraints { (make) in
			topConstraint = make.top.equalTo(letsRunButton.snp.bottom).offset(self.view.bounds.height).constraint
			leadingConstraint = make.leading.equalTo(letsRunButton.snp.leading).constraint
			trailingConstraint = make.trailing.equalTo(letsRunButton.snp.trailing).constraint
			bottomConstraint = make.bottom.equalTo(view.snp.bottom).offset(self.view.bounds.height).constraint
		}
	}
}



// MARK: - LetsRunDelegate

extension RunViewController: LetsRunDelegate {
	
	func startRun(with type: RunSelectionType) {
		debugPrint(#function)
	}
	
	func cancel() {
		self.viewType = .normal
	}
}
