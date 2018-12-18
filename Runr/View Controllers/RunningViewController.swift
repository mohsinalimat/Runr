//
//  RunManagerViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 10/7/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

class RunningViewController: UIViewController {
	
	class func build(runningController: RunningController) -> RunningViewController {
		let viewController = RunningViewController()
		viewController.runningController = runningController
		return viewController
	}
	
	
	// MARK: - Variables
	
	private var runningController: RunningController!
	
	
	
	// MARK: - Lifecyle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override func loadView() {
		view = UIView()
	}
	
	
	
	// MARK: - User Actions
	
	@IBAction func startRun(_ sender: UIButton) {
		runningController.startRun(with: .outdoor)
	}
	
	
	@IBAction func pauseRun(_ sender: UIButton) {
		runningController.pauseRun()
	}
	
	
	@IBAction func endRun(_ sender: UIButton) {
		runningController.endRun()
	}
}
