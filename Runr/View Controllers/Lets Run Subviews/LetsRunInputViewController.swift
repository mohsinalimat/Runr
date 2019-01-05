//
//  LetsRunInputViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 1/3/19.
//  Copyright © 2019 Philip Sawyer. All rights reserved.
//

import UIKit

class LetsRunSubViewController: UIViewController {
	var value: Double = 0.0
}

class LetsRunInputViewController: UIViewController {
	
	class func build(with runSelectionType: RunSelectionType, contentViewController: LetsRunSubViewController) -> LetsRunInputViewController {
		let viewController = LetsRunInputViewController()
		viewController.runSelectionType = runSelectionType
		viewController.contentViewController = contentViewController
		return viewController
	}
	
	
	// MARK: - UI Variables
	
	private lazy var chooseRunLabel: UILabel = {
		let label = UILabel()
		label.text = titleDisplayString
		label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		label.textColor = .runrGray
		label.textAlignment = .center
		return label
	}()
	
	private var contentViewController: LetsRunSubViewController!
	
	private lazy var startButton: UIButton = {
		let button = UIButton()
		button.setTitle("START", for: .normal)
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
		
		[chooseRunLabel, contentViewController.view, startButton, cancelButton].forEach {
			view.addSubview($0)
		}
		
		chooseRunLabel.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top).inset(10)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
		}
		
		contentViewController.view.snp.makeConstraints { (make) in
			make.top.equalTo(chooseRunLabel.snp.bottom).inset(10)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
		}
		
		startButton.snp.makeConstraints { (make) in
			make.top.equalTo(contentViewController.view.snp.bottom).inset(10)
			make.leading.equalTo(view.snp.trailing).inset(40)
			make.trailing.equalTo(view.snp.trailing).inset(-40)
			
			make.height.equalTo(65)
		}
		
		cancelButton.snp.makeConstraints { (make) in
			make.top.equalTo(startButton.snp.bottom).inset(-25)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
		}
	}
}



// MARK: -

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
