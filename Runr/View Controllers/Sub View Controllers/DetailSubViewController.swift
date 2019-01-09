//
//  DetailSubViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 1/8/19.
//  Copyright © 2019 Philip Sawyer. All rights reserved.
//

import UIKit

class DetailSubViewController: UIViewController {
	
	class func build() -> DetailSubViewController {
		let viewController = DetailSubViewController()
		return viewController
	}
	
	
	
	// MARK: - UI Variables
	
	lazy var averagePaceLabel: UILabel = UILabel.valueLabel()
	
	private lazy var averagePaceDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Avg Pace")
	
	lazy var distanceLabel: UILabel = UILabel.valueLabel()
	
	private lazy var distanceDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Distance")
	
	lazy var durationLabel: UILabel = UILabel.valueLabel()
	
	private lazy var durationDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Duration")
	
	lazy var elevationLabel: UILabel = UILabel.valueLabel()
	
	private lazy var elevationDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Elevation")
	
	lazy var heartRateLabel: UILabel = UILabel.valueLabel(color: .red)
	
	private lazy var heartRateDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Avg Heart Rate")
	
	lazy var estimatedCaloriesLabel: UILabel = UILabel.valueLabel()
	
	private lazy var estimatedCaloriesDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Est Calories")
	
	private lazy var paceStackView: UIStackView = UIStackView.detailStackView(with: [averagePaceLabel, averagePaceDescriptionLabel])
	
	private lazy var distanceStackView: UIStackView = UIStackView.detailStackView(with: [distanceLabel, distanceDescriptionLabel])
	
	private lazy var durationStackView: UIStackView = UIStackView.detailStackView(with: [durationLabel, durationDescriptionLabel])
	
	private lazy var elevationStackView: UIStackView = UIStackView.detailStackView(with: [elevationLabel, elevationDescriptionLabel])
	
	private lazy var heartRateStackView: UIStackView = UIStackView.detailStackView(with: [heartRateLabel, heartRateDescriptionLabel])
	
	private lazy var estimatedCaloriesStackView: UIStackView = UIStackView.detailStackView(with: [estimatedCaloriesLabel,
																								  estimatedCaloriesDescriptionLabel])
	
	private lazy var topStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [paceStackView, distanceStackView, durationStackView])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		return stackView
	}()
	
	private lazy var bottomStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [elevationStackView, heartRateStackView, estimatedCaloriesStackView])
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		return stackView
	}()
	
	private lazy var wholeStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
		stackView.axis = .vertical
		stackView.spacing = 20
		return stackView
	}()
	
	
	
	// MARK: - Lifecycle Methods
	
	override func loadView() {
		view = wholeStackView
	}
}


private extension UILabel {
	
	static func valueLabel(color: UIColor = .black) -> UILabel {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
		label.textAlignment = .center
		label.textColor = color
		return label
	}
	
	static func descriptionLabel(with text: String) -> UILabel {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		label.textAlignment = .center
		label.textColor = UIColor.runrGray
		label.text = text
		return label
	}
}


private extension UIStackView {
	
	static func detailStackView(with subviews: [UIView]) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: subviews)
		stackView.alignment = .center
		stackView.axis = .vertical
		stackView.spacing = 1
		return stackView
	}
}
