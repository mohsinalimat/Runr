//
//  LetsRunInputViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 1/3/19.
//  Copyright © 2019 Philip Sawyer. All rights reserved.
//

import UIKit

class LetsRunSubViewController: UIViewController {
	@objc dynamic var value: Double = 0.0
}

class LetsRunInputViewController: UIViewController {
	
	class func build(with runSelectionType: RunSelectionType, delegate: LetsRunDelegate?) -> LetsRunInputViewController {
		let viewController = LetsRunInputViewController()
		viewController.runSelectionType = runSelectionType
		viewController.delegate = delegate
		return viewController
	}
	
	
	// MARK: - UI Variables
	
	private lazy var contentViewController: LetsRunSubViewController = {
		switch runSelectionType! {
		case .open:
			return LetsRunSubViewController() // shouldn't get here in this view
		case .timed:
			return LetsRunSelectTimeSubViewController.build()
		case .distance:
			return LetsRunSelectValueSubViewController.build(with: runSelectionType!)
		case .calories:
			return LetsRunSelectValueSubViewController.build(with: runSelectionType!)
		}
	}()
	
	private lazy var startButton: UIButton = {
		let button = UIButton()
		button.setTitle("START", for: .normal)
		button.layer.cornerRadius = 10
		button.layer.backgroundColor = UIColor.runrGreen.cgColor
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
		button.addTarget(self, action: #selector(startAction(_:)), for: .touchUpInside)
		return button
	}()
	
	
	
	// MARK: - Variables
	
	private var runSelectionType: RunSelectionType!
	
	private weak var delegate: LetsRunDelegate?
	
	var titleString: String {
		switch runSelectionType! {
		case .open:
			return "" // shouldn't get here
		case .timed:
			return "Select a Time"
		case .distance:
			return "Enter Distance"
		case .calories:
			return "Enter Calories"
		}
	}
	
	
	
	// MARK: - Lifecyle Methods
	
	override func loadView() {
		view = UIView()
		
		[contentViewController.view, startButton].forEach {
			view.addSubview($0)
		}
		
		contentViewController.view.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top).inset(10)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
		}
		
		startButton.snp.makeConstraints { (make) in
			make.top.equalTo(contentViewController.view.snp.bottom).inset(-25)
			make.leading.equalTo(view.snp.leading).inset(40)
			make.trailing.equalTo(view.snp.trailing).inset(40)
			make.bottom.equalTo(view.snp.bottom)
			
			make.height.equalTo(65)
		}
	}
	
	
	
	// MARK: - Actions
	
	@objc private func startAction(_ sender: UIButton) {
		switch runSelectionType! {
		case .open:
			break // Shouldn't get here in this view
		case .timed:
			let timedSelection = RunSelectionType.timed(time: contentViewController.value)
			delegate?.startRun(with: timedSelection)
		case .distance:
			let distanceSelection = RunSelectionType.distance(distance: contentViewController.value)
			delegate?.startRun(with: distanceSelection)
		case .calories:
			let caloriesSelection = RunSelectionType.calories(calories: contentViewController.value)
			delegate?.startRun(with: caloriesSelection)
		}
	}
}



// MARK: - Helper Functions

extension LetsRunInputViewController {
	
	fileprivate var titleDisplayString: String {
		switch runSelectionType! {
		case .open:
			return "" // Shouldn't get here in this view
		case .timed:
			return "Select a Time"
		case .distance:
			return "Enter Distance"
		case .calories:
			return "Enter Calories"
		}
	}
}
