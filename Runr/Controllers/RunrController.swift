//
//  RunrController.swift
//  Runr
//
//  Created by Philip Sawyer on 11/19/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation
import WatchConnectivity

class RunrController: NSObject {
	
	private var connectivityController: ConnectivityController
	
	private var dataController: DataController
	
	var runningController: RunningController
	
	var locationController: LocationController
	
	
	@objc dynamic var currentModelInfoDebugString: String?
	
	
	init(connectivityController: ConnectivityController) {
		self.connectivityController = connectivityController
		self.dataController = DataController()
		self.locationController = LocationController()
		self.runningController = RunningController(locationController: locationController, dataController: dataController,
												   connectivityController: connectivityController)
		
		super.init()
		
		self.connectivityController.connectionDelegate = self
	}
}



// MARK: - ConnectivityControllerDelegate

extension RunrController: ConnectivityControllerDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		debugPrint(#file, #function, session, activationState, String(describing: error))
	}
	
	func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
		debugPrint(#file, #function, session, userInfo)
		
		guard
			let updateTypeValue = userInfo[ConnectivityController.updateTypeKey] as? Int,
			let updateType = ConnectivityController.UpdateType(rawValue: updateTypeValue),
			let updateData = userInfo[ConnectivityController.userInfoDataKey] as? Data
		else { return }
		
		switch updateType {
		case .start:
			let startModel = try! JSONDecoder().decode(StartModel.self, from: updateData)
			debugPrint(startModel)
			dataController.createRun(from: startModel)
			currentModelInfoDebugString = String(describing: startModel)
		case .pause:
			let pauseModel = try! JSONDecoder().decode(PauseModel.self, from: updateData)
			debugPrint(pauseModel)
			currentModelInfoDebugString = String(describing: pauseModel)
		case .resume:
			let resumeModel = try! JSONDecoder().decode(ResumeModel.self, from: updateData)
			debugPrint(resumeModel)
			currentModelInfoDebugString = String(describing: resumeModel)
		case .end:
			let endModel = try! JSONDecoder().decode(EndModel.self, from: updateData)
			debugPrint(endModel)
			dataController.endRun(with: endModel)
			currentModelInfoDebugString = String(describing: endModel)
		case .heartRate:
			let heartRateModel = try! JSONDecoder().decode(HeartRateModel.self, from: updateData)
			debugPrint(heartRateModel)
			dataController.handleHeartRate(with: heartRateModel)
			currentModelInfoDebugString = String(describing: heartRateModel)
		case .activeEnergyBurned:
			let activeEnergyModel = try! JSONDecoder().decode(ActiveEnergyModel.self, from: updateData)
			debugPrint(activeEnergyModel)
			currentModelInfoDebugString = String(describing: activeEnergyModel)
		case .distance:
			let distanceModel = try! JSONDecoder().decode(DistanceModel.self, from: updateData)
			debugPrint(distanceModel)
			currentModelInfoDebugString = String(describing: distanceModel)
		case .location:
			let locationModel = try! JSONDecoder().decode(LocationModel.self, from: updateData)
			debugPrint(locationModel)
			dataController.handleLocation(with: locationModel)
			currentModelInfoDebugString = String(describing: locationModel)
		}
	}
}
