//
//  RunViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 1/2/19.
//  Copyright © 2019 Philip Sawyer. All rights reserved.
//

import UIKit

class RunViewController: UIViewController {
	
	class func build(with runSelectionType: RunSelectionType) -> RunViewController {
		let viewController = RunViewController()
		viewController.runSelectionType = runSelectionType
		return viewController
	}
	
	// MARK: - UI Variables
	
	
	
	// MARK: - Variables
	
	private var runSelectionType: RunSelectionType!
	
	
	
	// MARK: - Lifecyle Methods
	
	override func loadView() {
		view = UIView()
	}
}
