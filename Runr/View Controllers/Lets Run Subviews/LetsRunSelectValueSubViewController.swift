//
//  LetsRunSelectValueSubViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 1/5/19.
//  Copyright © 2019 Philip Sawyer. All rights reserved.
//

import UIKit

class LetsRunSelectValueSubViewController: LetsRunSubViewController {
	
	class func build(with runSelectionType: RunSelectionType) -> LetsRunSelectValueSubViewController {
		let viewController = LetsRunSelectValueSubViewController()
		viewController.runSelectionType = runSelectionType
		return viewController
	}
	
	
	
	// MARK: - UI Variables
	
	private lazy var minusButton: UIButton = {
		let button = UIButton.minusButton
		button.addTarget(self, action: #selector(decrementValue(_:)), for: .touchDownRepeat)
		return button
	}()
	
	private lazy var addButton: UIButton = {
		let button = UIButton.addButton
		button.addTarget(self, action: #selector(incrementValue(_:)), for: .touchDownRepeat)
		return button
	}()
	
	private lazy var valueLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 60, weight: .bold)
		label.textAlignment = .center
		return label
	}()
	
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		return label
	}()
	
	private lazy var mainStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [minusButton, valueLabel, addButton])
		stackView.axis = .horizontal
		return stackView
	}()
	
	
	
	// MARK: - Variables
	
	private var runSelectionType: RunSelectionType!
	
	
	
	// MARK: - Lifecyle Methods
	
	override func loadView() {
		view = UIView()
		
		[mainStackView, descriptionLabel].forEach {
			view.addSubview($0)
		}
		
		mainStackView.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top)
			make.leading.equalTo(view.snp.leading).inset(25)
			make.trailing.equalTo(view.snp.trailing).inset(-25)
		}
		
		descriptionLabel.snp.makeConstraints { (make) in
			make.top.equalTo(mainStackView.snp.bottom)
			make.centerX.equalTo(mainStackView.snp.centerX)
			make.bottom.equalTo(view.snp.bottom).inset(10)
		}
	}
	
	
	
	// MARK: - Actions
	
	@objc func decrementValue(_ sender: UIButton) {
		guard value >= 0.1 else { return }
		switch runSelectionType! {
		case .calories:
			value -= 1
		case .distance:
			value -= 0.1
		case .open, .timed:
			break
		}
	}
	
	@objc func incrementValue(_ sender: UIButton) {
		switch runSelectionType! {
		case .calories:
			value += 1
		case .distance:
			value += 0.1
		case .open, .timed:
			break
		}
	}
}
