//
//  LetsRunSelectTimeSubViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 1/4/19.
//  Copyright © 2019 Philip Sawyer. All rights reserved.
//

import UIKit

class LetsRunSelectTimeSubViewController: LetsRunSubViewController {
	
	class func build() -> LetsRunSelectTimeSubViewController {
		let viewController = LetsRunSelectTimeSubViewController()
		return viewController
	}
	
	
	
	// MARK: - UI Variables
	
	private lazy var datePicker: UIDatePicker = {
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .countDownTimer
		return datePicker
	}()
	
	
	
	// MARK: - Lifecyle Methods
	
	override func loadView() {
		view = UIView()
		
		[datePicker].forEach {
			view.addSubview($0)
		}
		
		datePicker.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}
