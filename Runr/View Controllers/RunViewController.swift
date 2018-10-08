//
//  RunViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 8/25/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

class RunViewController: UIViewController {
	
	// MARK: - Variables
	
	private var dataController: DataController
	
	private var runningController: RunningController
	
	private lazy var runManagerViewController: RunManagerViewController = {
		let viewController = RunManagerViewController.build(dataController: dataController,
															runningController: runningController)
		return viewController
	}()
	
	
	// MARK: - Lifecycle Methods
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		self.dataController = DataController()
		self.runningController = RunningController()
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		self.dataController = DataController()
		self.runningController = RunningController()
		
		super.init(coder: aDecoder)
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
}
