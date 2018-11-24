//
//  ConnectivityController.swift
//  Runr
//
//  Created by Philip Sawyer on 11/17/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation
import WatchConnectivity

@objc enum RunType: Int, Codable {
	case outdoor
	case indoor
}

protocol ConnectivityControllerDelegate: class {
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?)
}

class ConnectivityController: NSObject {
	
	static let userInfoDataKey = "userInfo"
	
	weak var connectionDelegate: ConnectivityControllerDelegate?
	
	enum UpdateType: Int, Codable {
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
