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
	
	init(connectivityController: ConnectivityController) {
		self.connectivityController = connectivityController
		self.dataController = DataController()
		self.locationController = LocationController()
		self.runningController = RunningController(locationController: locationController, dataController: dataController)
		
		super.init()
		
		self.connectivityController.connectionDelegate = self
	}
}


extension RunrController: ConnectivityControllerDelegate {
	
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		debugPrint(#file, #function, session, activationState, String(describing: error))
	}
}
