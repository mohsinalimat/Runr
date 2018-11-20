//
//  RunManagerViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 10/7/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

class RunManagerViewController: UIViewController {
	
	class func build(runrController: RunrController) -> RunManagerViewController {
		let storyboard = UIStoryboard(name: className, bundle: nil)
		let viewController = storyboard.instantiateInitialViewController() as! RunManagerViewController
		viewController.runrController = runrController
		return viewController
	}
	
	
	
	// MARK: - Variables
	
	private var runrController: RunrController!
	
	
	
	// MARK: - Lifecyle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	
	
	// MARK: - User Actions
	
	@IBAction func startRun(_ sender: UIButton) {
		
	}
	
	
	@IBAction func pauseRun(_ sender: UIButton) {
		
	}
	
	
	@IBAction func endRun(_ sender: UIButton) {
		
	}
}
