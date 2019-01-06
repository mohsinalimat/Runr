//
//  LetsRunViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 12/29/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

import SnapKit

/// The delegate for the LetsRunViewController
protocol LetsRunDelegate: class {
	func startRun(with type: RunSelectionType)
	func cancel()
}

/// The selection type
enum RunSelectionType {
	case open
	case timed(time: TimeInterval)
	case distance(distance: Double)
	case calories(calories: Double)
}

class LetsRunViewController: UIViewController {
	
	class func build(delegate: LetsRunDelegate) -> LetsRunViewController {
		let viewController = LetsRunViewController()
		viewController.delegate = delegate
		return viewController
	}
	
	
	
	// MARK: - UI Variables
	
	private lazy var chooseRunLabel: UILabel = {
		let label = UILabel()
		label.text = "Choose a Run Type"
		label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
		label.textColor = .runrGray
		label.textAlignment = .center
		return label
	}()
	
	private lazy var openRunButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.openGoalIcon, for: .normal)
		button.addTarget(self, action: #selector(openButtonAction(_:)), for: .touchUpInside)
		return button
	}()
	
	private lazy var openRunLabel: UILabel = {
		let label = UILabel()
		label.text = "Open"
		label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
		label.textColor = .runrGray
		return label
	}()
	
	private lazy var timedRunButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.timedGoalIcon, for: .normal)
		button.addTarget(self, action: #selector(timedButtonAction(_:)), for: .touchUpInside)
		return button
	}()
	
	private lazy var timedLabel: UILabel = {
		let label = UILabel()
		label.text = "Timed"
		label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
		label.textColor = .runrGray
		return label
	}()
	
	private lazy var distanceRunButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.distanceGoalIcon, for: .normal)
		button.addTarget(self, action: #selector(distanceButtonAction(_:)), for: .touchUpInside)
		return button
	}()
	
	private lazy var distanceLabel: UILabel = {
		let label = UILabel()
		label.text = "Distance"
		label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
		label.textColor = .runrGray
		return label
	}()
	
	private lazy var caloriesRunButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.caloriesGoalIcon, for: .normal)
		button.addTarget(self, action: #selector(caloriesButtonAction(_:)), for: .touchUpInside)
		return button
	}()
	
	private lazy var caloriesLabel: UILabel = {
		let label = UILabel()
		label.text = "Calories"
		label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
		label.textColor = .runrGray
		return label
	}()
	
	private lazy var openRunView = UIStackView.actionStackView(with: [openRunButton, openRunLabel])
	
	private lazy var timedRunView = UIStackView.actionStackView(with: [timedRunButton, timedLabel])
	
	private lazy var distanceRunView = UIStackView.actionStackView(with: [distanceRunButton, distanceLabel])
	
	private lazy var caloriesRunView = UIStackView.actionStackView(with: [caloriesRunButton, caloriesLabel])
	
	private lazy var topStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [openRunView, timedRunView])
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		return stackView
	}()
	
	private lazy var bottomStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [distanceRunView, caloriesRunView])
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		return stackView
	}()
	
	private lazy var wholeStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
		stackView.axis = .vertical
		stackView.spacing = 20
		return stackView
	}()
	
	private lazy var cancelButton: UIButton = {
		let button = UIButton()
		button.setTitle("Cancel", for: .normal)
		button.setTitleColor(.runrGray, for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		button.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
		return button
	}()
	
	
	
	// MARK: - Variables
	
	private weak var delegate: LetsRunDelegate?
	
	private var selectionSubview: LetsRunInputViewController?
	
	var wholeStackLeadingConstraint: Constraint?
	
	var wholeStackTrailingConstraint: Constraint?
	
	var selectionSubviewLeadingConstraint: Constraint?
	
	var selectionSubviewTrailingConstraint: Constraint?
	
	
	
	// MARK: - Lifecyle Methods
	
	override func loadView() {
		view = UIView()
		
		view.layer.backgroundColor = UIColor.white.cgColor
		view.layer.cornerRadius = 25
		
		[chooseRunLabel, wholeStackView, cancelButton].forEach {
			view.addSubview($0)
		}
		
		chooseRunLabel.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top).inset(10)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
		}
		
		wholeStackView.snp.makeConstraints { (make) in
			make.top.equalTo(chooseRunLabel.snp.bottom).inset(-15)
			self.wholeStackLeadingConstraint = make.leading.equalTo(view.snp.leading).constraint
			self.wholeStackTrailingConstraint = make.trailing.equalTo(view.snp.trailing).constraint
		}
		
		cancelButton.snp.makeConstraints { (make) in
			make.top.equalTo(wholeStackView.snp.bottom).inset(-5)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Choose a Run Type"
	}
	
	
	
	// MARK: - Actions
	
	@objc private func cancel(_ sender: UIButton) {
		if self.selectionSubview != nil {
			transitionBackToOriginalView()
		} else {
			delegate?.cancel()
		}
	}
	
	@objc func openButtonAction(_ sender: UIButton) {
		delegate?.startRun(with: .open)
	}
	
	@objc func timedButtonAction(_ sender: UIButton) {
		selectionSubview = LetsRunInputViewController.build(with: .timed(time: 0), delegate: self.delegate)
		transitionToSelectionSubview()
	}
	
	@objc func distanceButtonAction(_ sender: UIButton) {
		selectionSubview = LetsRunInputViewController.build(with: .distance(distance: 0), delegate: self.delegate)
		transitionToSelectionSubview()
	}
	
	@objc func caloriesButtonAction(_ sender: UIButton) {
		selectionSubview = LetsRunInputViewController.build(with: .calories(calories: 0), delegate: self.delegate)
		transitionToSelectionSubview()
	}
	
	private func transitionToSelectionSubview() {
		guard let selectionSubview = self.selectionSubview?.view else { return }
		
		view.addSubview(selectionSubview)
		selectionSubview.snp.makeConstraints { (make) in
			make.top.equalTo(chooseRunLabel.snp.bottom).inset(-15)
			self.selectionSubviewLeadingConstraint = make.leading.equalTo(view.snp.leading).offset(self.view.bounds.width).constraint
			self.selectionSubviewTrailingConstraint = make.trailing.equalTo(view.snp.trailing).offset(self.view.bounds.width).constraint
			make.bottom.equalTo(cancelButton.snp.top).offset(-25)
		}
		view.layoutIfNeeded()
		
		UIView.animate(withDuration: 0.3) {
			self.wholeStackLeadingConstraint?.update(offset: -self.view.bounds.width)
			self.wholeStackTrailingConstraint?.update(offset: -self.view.bounds.width)
			
			self.selectionSubviewLeadingConstraint?.update(offset: 0)
			self.selectionSubviewTrailingConstraint?.update(offset: 0)
			
			self.chooseRunLabel.text = self.selectionSubview?.titleString
			
			self.view.layoutIfNeeded()
		}
	}
	
	private func transitionBackToOriginalView() {
		UIView.animate(withDuration: 0.3, animations: {
			self.wholeStackLeadingConstraint?.update(offset: 0)
			self.wholeStackTrailingConstraint?.update(offset: 0)
			
			self.selectionSubviewLeadingConstraint?.update(offset: self.view.bounds.width)
			self.selectionSubviewTrailingConstraint?.update(offset: self.view.bounds.width)
			
			self.view.layoutIfNeeded()
		}, completion: { (_) in
			self.selectionSubviewLeadingConstraint = nil
			self.selectionSubviewTrailingConstraint = nil
			self.selectionSubview = nil
			
			self.title = "Choose a Run Type"
		})
	}
}



// MARK: - UIStackView Extension

private extension UIStackView {
	
	static func actionStackView(with arrangedSubviews: [UIView]) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.spacing = 5
		return stackView
	}
}
