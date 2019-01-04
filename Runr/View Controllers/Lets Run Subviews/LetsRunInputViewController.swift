//
//  LetsRunInputViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 1/3/19.
//  Copyright © 2019 Philip Sawyer. All rights reserved.
//

import UIKit

class LetsRunInputViewController: UIViewController {
	
	class func build(with runSelectionType: RunSelectionType, contentViewController: UIViewController) -> LetsRunInputViewController {
		let viewController = LetsRunInputViewController()
		viewController.runSelectionType = runSelectionType
		viewController.contentViewController = contentViewController
		return viewController
	}
	
	
	// MARK: - UI Variables
	
	private var contentViewController: UIViewController!
	
	private lazy var startButton: UIButton = {
		let button = UIButton()
		button.layer.cornerRadius = 10
		button.layer.backgroundColor = UIColor.runrGreen.cgColor
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
		return button
	}()
	
	private lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.setTitle("Cancel", for: .normal)
		button.setTitleColor(.runrGray, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		return button
	}()
	
	
	// MARK: - Variables
	
	private var runSelectionType: RunSelectionType!
	
	
	
	// MARK: - Lifecyle Methods
	
	override func loadView() {
		view = UIView()
	}
}
