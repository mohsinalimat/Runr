//
//  UIImage+Extensions.swift
//  Runr
//
//  Created by Philip Sawyer on 12/26/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

extension UIImage {
	
	// MARK: - General Images
	static var disclosureIndicator: UIImage {
		return UIImage(named: "DisclosureIndicator")!
	}
	
	static var backArrow: UIImage {
		return UIImage(named: "BackArrow")!
	}
	
	
	
	// MARK: - Lets Run View Controller
	
	static var openGoalIcon: UIImage {
		return UIImage(named: "OpenGoal")!
	}
	
	static var timedGoalIcon: UIImage {
		return UIImage(named: "TimedGoal")!
	}
	
	static var distanceGoalIcon: UIImage {
		return UIImage(named: "DistanceGoal")!
	}
	
	static var caloriesGoalIcon: UIImage {
		return UIImage(named: "CaloriesGoal")!
	}
}
