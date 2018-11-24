//
//  ConnectivityModel.swift
//  Runr
//
//  Created by Philip Sawyer on 11/23/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation

protocol ConnectivityModel: Codable {
	var updateType: ConnectivityController.UpdateType { get }
	var runUUID: UUID { get }
}

struct StartModel: ConnectivityModel {
	let runUUID: UUID
	var startTime: Date
	var runType: RunType
	var updateType: ConnectivityController.UpdateType
	
	init(runUUID: UUID, startTime: Date, runType: RunType) {
		self.runUUID = runUUID
		self.startTime = startTime
		self.runType = runType
		self.updateType = .start
	}
	
	private enum CodingKeys: String, CodingKey {
		case runUUID
		case startTime
		case runType
		case updateType
	}
}

struct PauseModel: ConnectivityModel {
	let runUUID: UUID
	var pauseTime: Date
	var updateType: ConnectivityController.UpdateType
	
	init(runUUID: UUID, pauseTime: Date) {
		self.runUUID = runUUID
		self.pauseTime = pauseTime
		self.updateType = .pause
	}
	
	private enum CodingKeys: String, CodingKey {
		case runUUID
		case pauseTime
		case updateType
	}
}

struct EndModel: ConnectivityModel {
	var runUUID: UUID
	var endTime: Date
	var updateType: ConnectivityController.UpdateType
	
	init(runUUID: UUID, endTime: Date) {
		self.runUUID = runUUID
		self.endTime = endTime
		self.updateType = .end
	}
	
	private enum CodingKeys: String, CodingKey {
		case runUUID
		case endTime
		case updateType
	}
}

struct ResumeModel: ConnectivityModel {
	var runUUID: UUID
	var resumeTime: Date
	var updateType: ConnectivityController.UpdateType
	
	init(runUUID: UUID, resumeTime: Date) {
		self.runUUID = runUUID
		self.resumeTime = resumeTime
		self.updateType = .resume
	}
	
	private enum CodingKeys: String, CodingKey {
		case runUUID
		case resumeTime
		case updateType
	}
}

struct HeartRateModel: ConnectivityModel {
	var runUUID: UUID
	var timeStamp: Date
	var heartRate: Double
	var updateType: ConnectivityController.UpdateType
	
	init(runUUID: UUID, heartRate: Double, timeStamp: Date) {
		self.runUUID = runUUID
		self.timeStamp = timeStamp
		self.heartRate = heartRate
		self.updateType = .heartRate
	}
	
	private enum CodingKeys: String, CodingKey {
		case runUUID
		case timeStamp
		case heartRate
		case updateType
	}
}

struct ActiveEnergyModel: ConnectivityModel {
	var runUUID: UUID
	var calorieCount: Double
	var updateType: ConnectivityController.UpdateType
	
	init(runUUID: UUID, calorieCount: Double) {
		self.runUUID = runUUID
		self.calorieCount = calorieCount
		self.updateType = .activeEnergyBurned
	}
	
	private enum CodingKeys: String, CodingKey {
		case runUUID
		case calorieCount
		case updateType
	}
}

struct DistanceModel: ConnectivityModel {
	var runUUID: UUID
	var distance: Double
	var updateType: ConnectivityController.UpdateType
	
	init(runUUID: UUID, distance: Double) {
		self.runUUID = runUUID
		self.distance = distance
		self.updateType = .distance
	}
	
	private enum CodingKeys: String, CodingKey {
		case runUUID
		case distance
		case updateType
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
	var updateType: ConnectivityController.UpdateType
	
	init(runUUID: UUID, latitude: Double, longitude: Double, altitude: Double,
		 floor: Int, horizontalAccuracy: Double, verticalAccuracy: Double, speed: Double, timeStamp: Date) {
		self.runUUID = runUUID
		self.latitude = latitude
		self.longitude = longitude
		self.altitude = altitude
		self.floor = floor
		self.horizontalAccuracy = horizontalAccuracy
		self.verticalAccuracy = verticalAccuracy
		self.speed = speed
		self.timeStamp = timeStamp
		self.updateType = .location
	}
	
	private enum CodingKeys: String, CodingKey {
		case runUUID
		case latitude
		case longitude
		case altitude
		case floor
		case horizontalAccuracy
		case verticalAccuracy
		case speed
		case timeStamp
		case updateType
	}
}
