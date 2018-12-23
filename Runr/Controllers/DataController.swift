//
//  DataController.swift
//  Runr
//
//  Created by Philip Sawyer on 8/25/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation

import RealmSwift

class DataController {
	
	let realm: Realm
	
	@objc dynamic var allRuns: [Run] = []
	
	init() {
		realm = try! Realm()
		
		debugPrint("realm path: \(String(describing: realm.configuration.fileURL))")
		
		performInitialDataFetch()
	}
	
	
	
	// MARK: - Initial Data Fetching
	
	private func performInitialDataFetch() {
		let sortedRuns = realm.objects(Run.self).sorted(byKeyPath: #keyPath(Run.startDate))
		self.allRuns = sortedRuns.map { $0 }
	}
	
	
	
	// MARK: - Adding Runs
	
	func add(run: Run) {
		try! realm.write {
			realm.add(run)
			allRuns.append(run)
		}
	}
	
	
	// MARK: - Editing Runs
	
	func update(run: Run, startDate: Date) {
		try! realm.write {
			run.startDate = startDate
		}
	}
	
	
	func update(run: Run, endDate: Date) {
		try! realm.write {
			run.endDate = endDate
		}
	}
	
	
	func update(run: Run, runType: RunType) {
		try! realm.write {
			run.runType = runType
		}
	}
	
	
	func update(run: Run, duration: TimeInterval) {
		try! realm.write {
			run.duration = duration
		}
	}
	
	
	func update(run: Run, state: RunState) {
		try! realm.write {
			run.state = state
		}
	}
	
	
	func update(run: Run, distance: Double) {
		try! realm.write {
			run.distance = distance
		}
	}
	
	
	func update(run: Run, newLocations: [Location]) {
		try! realm.write {
			run.locations.append(objectsIn: newLocations)
		}
	}
	
	
	func update(run: Run, newHeartRates: [HeartRateObject]) {
		try! realm.write {
			run.heartRates.append(objectsIn: newHeartRates)
		}
	}
	
	
	
	// MARK: - Removing Runs
	
	func remove(run: Run) {
		try! realm.write {
			realm.delete(run)
			if let index = allRuns.index(of: run) {
				allRuns.remove(at: index)
			}
		}
	}
}



// MARK: - ConnectivityModel Updates

extension DataController {
	
	func createRun(from startModel: StartModel) {
		let run = Run(uuid: startModel.runUUID)
		run.startDate = startModel.startTime
		run.runType = startModel.runType
		
		DispatchQueue.main.async {
			self.add(run: run)
		}
	}
	
	
	func endRun(with endModel: EndModel) {
		DispatchQueue.main.async {
			let predicate = NSPredicate(format: "uuidString == %@", endModel.runUUID.uuidString)
			guard let run = self.realm.objects(Run.self).filter(predicate).first else { return }
			self.update(run: run, endDate: endModel.endTime)
		}
	}
	
	
	func handleHeartRate(with heartRateModel: HeartRateModel) {
		DispatchQueue.main.async {
			let predicate = NSPredicate(format: "uuidString == %@", heartRateModel.runUUID.uuidString)
			guard let run = self.realm.objects(Run.self).filter(predicate).first else { return }
			let heartRateObject = HeartRateObject()
			heartRateObject.heartRate = heartRateModel.heartRate
			heartRateObject.timestamp = heartRateModel.timeStamp
			
			self.update(run: run, newHeartRates: [heartRateObject])
		}
	}
	
	
	func handleLocation(with locationModel: LocationModel) {
		DispatchQueue.main.async {
			let predicate = NSPredicate(format: "uuidString == %@", locationModel.runUUID.uuidString)
			guard let run = self.realm.objects(Run.self).filter(predicate).first else { return }
			let location = Location()
			location.coordinate?.latitude = locationModel.latitude
			location.coordinate?.longitude = locationModel.longitude
			location.altitude = locationModel.altitude
			location.floor = locationModel.floor
			location.horizontalAccuracy = locationModel.horizontalAccuracy
			location.verticalAccuracy = locationModel.verticalAccuracy
			location.speed = locationModel.speed
			location.timestamp = locationModel.timeStamp
			
			self.update(run: run, newLocations: [location])
		}
	}
}
