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
		button.addTarget(self, action: #selector(minusButtonDown(_:)), for: .touchDown)
		button.addTarget(self, action: #selector(minusButtonUp(_:)), for: [.touchUpInside, .touchUpOutside])
		button.snp.makeConstraints({ (make) in
			make.height.equalTo(40)
			make.width.equalTo(button.snp.height)
		})
		return button
	}()
	
	private lazy var addButton: UIButton = {
		let button = UIButton.addButton
		button.addTarget(self, action: #selector(addButtonDown(_:)), for: .touchDown)
		button.addTarget(self, action: #selector(addButtonUp(_:)), for: [.touchUpInside, .touchUpOutside])
		button.snp.makeConstraints({ (make) in
			make.height.equalTo(40)
			make.width.equalTo(button.snp.height)
		})
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
		label.text = descriptionString
		return label
	}()
	
	private lazy var mainStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [minusButton, valueLabel, addButton])
		stackView.axis = .horizontal
		stackView.alignment = .center
		return stackView
	}()
	
	
	
	// MARK: - Variables
	
	private var runSelectionType: RunSelectionType!
	
	let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
	
	private var valueObserver: NSKeyValueObservation?
	
	private var decrementTimer: Timer?
	
	private var incrementTimer: Timer?
	
	private var descriptionString: String {
		switch runSelectionType! {
		case .open, .timed:
			return "" // should not get here in this view
		case .distance:
			return "Miles"
		case .calories:
			return "Calories"
		}
	}
	
	
	
	// MARK: - Lifecyle Methods
	
	override func loadView() {
		view = UIView()
		
		[mainStackView, descriptionLabel].forEach {
			view.addSubview($0)
		}
		
		mainStackView.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top)
			make.leading.equalTo(view.snp.leading).inset(25)
			make.trailing.equalTo(view.snp.trailing).inset(25)
		}
		
		descriptionLabel.snp.makeConstraints { (make) in
			make.top.equalTo(mainStackView.snp.bottom)
			make.centerX.equalTo(mainStackView.snp.centerX)
			make.bottom.equalTo(view.snp.bottom).inset(10)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupObservers()
	}
	
	
	
	// MARK: - Observers
	
	private func setupObservers() {
		valueObserver = self.observe(\.value, options: [.initial], changeHandler: { (object, _) in
			switch object.runSelectionType! {
			case .open, .timed:
			break // shouldn't get here
			case .distance:
				self.valueLabel.text = String(format: "%.2f", object.value)
			case .calories:
				self.valueLabel.text = "\(Int(object.value))" //String(format: "%", object.value)
			}
		})
	}
	
	
	// MARK: - Actions
	
	@objc func decrementValue() {
		guard value >= 0.01 else { return }
		switch runSelectionType! {
		case .calories:
			value -= 10
			feedbackGenerator.impactOccurred()
		case .distance:
			value -= 0.01
			feedbackGenerator.impactOccurred()
		case .open, .timed:
			break
		}
	}
	
	@objc func incrementValue() {
		switch runSelectionType! {
		case .calories:
			value += 10
			feedbackGenerator.impactOccurred()
		case .distance:
			value += 0.01
			feedbackGenerator.impactOccurred()
		case .open, .timed:
			break
		}
	}
	
	@objc private func minusButtonDown(_ sender: UIButton) {
		decrementValue()
		decrementTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(decrementValue), userInfo: nil, repeats: true)
	}
	
	@objc private func minusButtonUp(_ sender: UIButton) {
		decrementTimer?.invalidate()
	}
	
	@objc private func addButtonDown(_ sender: UIButton) {
		incrementValue()
		incrementTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(incrementValue), userInfo: nil, repeats: true)
	}
	
	@objc private func addButtonUp(_ sender: UIButton) {
		incrementTimer?.invalidate()
	}
}
