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
		
		performInitialDataFetch()
	}
	
	
	
	// MARK: - Initial Data Fetching
	
	private func performInitialDataFetch() {
		let sortedRuns = realm.objects(Run.self).sorted(byKeyPath: #keyPath(Run.startDate))
		self.allRuns = sortedRuns.map { $0 }
	}
	
	
	
	// MARK: - Adding Runs
	
	
	
	// MARK: - Editing Runs
	
	
	
	// MARK: - Removing Runs
}
