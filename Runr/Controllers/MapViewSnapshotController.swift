//
//  MapViewSnapshotController.swift
//  Runr
//
//  Created by Philip Sawyer on 12/27/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation
import MapKit

class MapViewSnapshotController {
	
	static func generateMapSnapshot(for run: Run, saveWith cacheController: CacheController? = nil) {
		guard run.locations.count > 0 else { return }
				
		let options = MKMapSnapshotter.Options()
		options.mapType = .standard
		options.showsPointsOfInterest = false
		options.showsBuildings = false
		options.size = CGSize(width: 500, height: 500)
		
		let locations = Array(run.locations).compactMap({ $0.coordinate }).map({ CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)})
		options.region = MKCoordinateRegion(coordinates: locations)
		
		let snapshotter = MKMapSnapshotter(options: options)
		snapshotter.start { (snapshot, error) in
			guard let image = snapshot?.image, error == nil else { return }
			cacheController?.set(image: image, for: run.uuidString)
		}
	}
}
