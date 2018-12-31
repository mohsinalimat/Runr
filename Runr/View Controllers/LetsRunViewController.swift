//
//  LetsRunViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 12/29/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

class LetsRunViewController: UIViewController {
	
	class func build() -> LetsRunViewController {
		let viewController = LetsRunViewController()
		return viewController
	}
	
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
		return button
	}()
	
	private lazy var openRunLabel: UILabel = {
		let label = UILabel()
		label.text = "Open"
		return label
	}()
	
	private lazy var timedRunButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.timedGoalIcon, for: .normal)
		return button
	}()
	
	private lazy var timedLabel: UILabel = {
		let label = UILabel()
		label.text = "Timed"
		return label
	}()
	
	private lazy var distanceRunButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.distanceGoalIcon, for: .normal)
		return button
	}()
	
	private lazy var distanceLabel: UILabel = {
		let label = UILabel()
		label.text = "Distance"
		return label
	}()
	
	private lazy var caloriesRunButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.caloriesGoalIcon, for: .normal)
		return button
	}()
	
	private lazy var caloriesLabel: UILabel = {
		let label = UILabel()
		label.text = "Calories"
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
		return button
	}()
	
	
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
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
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
}


private extension UIStackView {
	
	static func actionStackView(with arrangedSubviews: [UIView]) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.spacing = 5
		return stackView
	}
}
