//
//  ConnectivityController.swift
//  Runr
//
//  Created by Philip Sawyer on 11/17/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation
import WatchConnectivity

@objc enum RunType: Int {
	case outdoor
	case indoor
}

protocol ConnectivityControllerDelegate: class {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
}

class ConnectivityController: NSObject {
	
	weak var connectionDelegate: ConnectivityControllerDelegate?
	
	enum UpdateType: Int {
		case start
		case pause
		case resume
		case end
		case heartRate
		case activeEnergyBurned
		case distance
		case location
	}
}


extension ConnectivityController: WCSessionDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		connectionDelegate?.session(session, activationDidCompleteWith: activationState, error: error)
	}
	
	// WCSessionDelegate methods for iOS only.
	//
	#if os(iOS)
	func sessionDidBecomeInactive(_ session: WCSession) {
		print("\(#function): activationState = \(session.activationState.rawValue)")
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		// Activate the new session after having switched to a new watch.
		session.activate()
	}
	
	func sessionWatchStateDidChange(_ session: WCSession) {
		print("\(#function): activationState = \(session.activationState.rawValue)")
	}
	#endif
}



// MARK: - Connectivty Model

protocol ConnectivityModel {
	var updateType: ConnectivityController.UpdateType { get }
	var runUUID: UUID { get }
	var infoDict: [String: Any] { get }
}

extension ConnectivityController {
	
	struct StartModel: ConnectivityModel {
		let runUUID: UUID
		var startTime: Date
		var runType: RunType
		
		var updateType: ConnectivityController.UpdateType {
			return .start
		}
		
		var infoDict: [String: Any] {
			return [
				"runUUID": runUUID,
				"startTime": startTime,
				"runType": runType,
				"updateType": updateType
			]
		}
	}
	
	struct PauseModel: ConnectivityModel {
		let runUUID: UUID
		var pauseTime: Date
		
		var updateType: ConnectivityController.UpdateType {
			return .pause
		}
		
		var infoDict: [String: Any] {
			return [
				"runUUID": runUUID,
				"pauseTime": pauseTime,
				"updateType": updateType
			]
		}
	}
	
	struct EndModel: ConnectivityModel {
		var runUUID: UUID
		var endTime: Date
		
		var updateType: ConnectivityController.UpdateType {
			return .end
		}
		
		var infoDict: [String: Any] {
			return [
				"runUUID": runUUID,
				"endTime": endTime,
				"updateType": updateType
			]
		}
	}
	
	struct ResumeModel: ConnectivityModel {
		var runUUID: UUID
		var resumeTime: Date
		
		var updateType: ConnectivityController.UpdateType {
			return .resume
		}
		
		var infoDict: [String: Any] {
			return [
				"runUUID": runUUID,
				"resumeTime": resumeTime,
				"updateType": updateType
			]
		}
	}
	
	struct HeartRateModel: ConnectivityModel {
		var runUUID: UUID
		var timeStamp: Date
		
		var updateType: ConnectivityController.UpdateType {
			return .heartRate
		}
		
		var infoDict: [String: Any] {
			return [
				"runUUID": runUUID,
				"timeStamp": timeStamp,
				"updateType": updateType
			]
		}
	}
	
	struct ActiveEnergyModel: ConnectivityModel {
		var runUUID: UUID
		var calorieCount: Double
		
		var updateType: ConnectivityController.UpdateType {
			return .activeEnergyBurned
		}
		
		var infoDict: [String: Any] {
			return [
				"runUUID": runUUID,
				"calorieCount": calorieCount,
				"updateType": updateType
			]
		}
	}
	
	struct DistanceModel: ConnectivityModel {
		var runUUID: UUID
		var distance: Double
		
		var updateType: ConnectivityController.UpdateType {
			return .distance
		}
		
		var infoDict: [String: Any] {
			return [
				"runUUID": runUUID,
				"distance": distance,
				"updateType": updateType
			]
		}
	}
	
	struct LocationModel: ConnectivityModel {
		var runUUID: UUID
		var latitude: Double
		var longitude: Double
		var altitude: Double
		var floor: Int
		var horizontalAccuracy: Double
		var verticalAccuracy: Double
		var speed: Double
		var timeStamp: Date
		
		var updateType: ConnectivityController.UpdateType {
			return .location
		}
		
		var infoDict: [String: Any] {
			return [
				"runUUID": runUUID,
				"latitude": latitude,
				"longitude": longitude,
				"altitude": altitude,
				"floor": floor,
				"horizontalAccuracy": horizontalAccuracy,
				"verticalAccuracy": verticalAccuracy,
				"speed": speed,
				"timeStamp": timeStamp,
				"updateType": updateType
			]
		}
	}
}
