//
//  RunrController.swift
//  Runr
//
//  Created by Philip Sawyer on 11/19/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation

import CoreLocation
import WatchConnectivity

class RunrController: NSObject {
	
	var connectivityController: ConnectivityController
	
	var dataController: DataController
	
	var runningController: RunningController
	
	var locationController: LocationController
	
	
	@objc dynamic var currentModelInfoDebugString: String?
	
	
	override init() {
		self.connectivityController = ConnectivityController()
		self.dataController = DataController()
		self.locationController = LocationController()
		self.runningController = RunningController()
		
		super.init()
		
		self.connectivityController.connectionDelegate = self
		self.locationController.delegate = self
		self.runningController.runningControllerDelegate = self
	}
	
	
	private func handle(sessionData: Data, updateType: ConnectivityController.UpdateType) {
		switch updateType {
		case .start:
			let startModel = try! JSONDecoder().decode(StartModel.self, from: sessionData)
			debugPrint(startModel)
			dataController.createRun(from: startModel)
			currentModelInfoDebugString = String(describing: startModel)
		case .pause:
			let pauseModel = try! JSONDecoder().decode(PauseModel.self, from: sessionData)
			debugPrint(pauseModel)
			currentModelInfoDebugString = String(describing: pauseModel)
		case .resume:
			let resumeModel = try! JSONDecoder().decode(ResumeModel.self, from: sessionData)
			debugPrint(resumeModel)
			currentModelInfoDebugString = String(describing: resumeModel)
		case .end:
			let endModel = try! JSONDecoder().decode(EndModel.self, from: sessionData)
			debugPrint(endModel)
			dataController.endRun(with: endModel)
			currentModelInfoDebugString = String(describing: endModel)
		case .heartRate:
			let heartRateModel = try! JSONDecoder().decode(HeartRateModel.self, from: sessionData)
			debugPrint(heartRateModel)
			dataController.handleHeartRate(with: heartRateModel)
			currentModelInfoDebugString = String(describing: heartRateModel)
		case .activeEnergyBurned:
			let activeEnergyModel = try! JSONDecoder().decode(ActiveEnergyModel.self, from: sessionData)
			debugPrint(activeEnergyModel)
			currentModelInfoDebugString = String(describing: activeEnergyModel)
		case .distance:
			let distanceModel = try! JSONDecoder().decode(DistanceModel.self, from: sessionData)
			debugPrint(distanceModel)
			currentModelInfoDebugString = String(describing: distanceModel)
		case .location:
			let locationModel = try! JSONDecoder().decode(LocationModel.self, from: sessionData)
			debugPrint(locationModel)
			dataController.handleLocation(with: locationModel)
			currentModelInfoDebugString = String(describing: locationModel)
		}
	}
}



// MARK: - ConnectivityControllerDelegate

extension RunrController: ConnectivityControllerDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		debugPrint(#file, #function, session, activationState, String(describing: error))
	}
	
	func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
		guard
			let updateTypeValue = userInfo[ConnectivityController.updateTypeKey] as? Int,
			let updateType = ConnectivityController.UpdateType(rawValue: updateTypeValue),
			let updateData = userInfo[ConnectivityController.userInfoDataKey] as? Data
		else { return }
		
		handle(sessionData: updateData, updateType: updateType)
	}
}



// MARK: - RunningControllerDelegate

extension RunrController: RunningControllerDelegate {
	
	func create(run: Run) {
		dataController.add(run: run)
	}
	
	func startLocationUpdates() {
		locationController.startUpdatingLocations()
	}
	
	func stopLocationUpdates() {
		locationController.stopLocationUpdates()
	}
	
	func updateRunState(_ state: RunState) {
		guard let run = runningController.currentRun else { return }
		dataController.update(run: run, state: state)
	}
	
	func locations(for run: Run) -> [CLLocation] {
		// do i still need this?
		return []
	}
	
	func update(duration: TimeInterval) {
		guard let run = runningController.currentRun else { return }
		dataController.update(run: run, duration: duration)
	}
}


extension RunrController: LocationControllerDelegate {
	
	func didUpdateLocations(with locations: [CLLocation]) {
		guard let run = runningController.currentRun else { return }
		let convertedLocations = locations.map { Location(cllocation: $0) }
		run.locations.append(objectsIn: convertedLocations)
		dataController.update(run: run, newLocations: convertedLocations)
	}
	
	func didFail(with error: Error) {
		debugPrint(#file, #function, error.localizedDescription)
	}
	
	func didChangeAuthoriztionStatus(_ status: CLAuthorizationStatus) {
		debugPrint(#file, #function, status)
	}
}
