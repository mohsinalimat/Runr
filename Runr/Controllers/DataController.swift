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
		}
	}
}
