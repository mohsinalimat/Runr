//
//  RunDetailViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 12/27/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

import SnapKit

class RunDetailViewController: UIViewController {
	
	class func build(with run: Run) -> RunDetailViewController {
		let viewController = RunDetailViewController()
		viewController.run = run
		return viewController
	}
	
	
	
	// MARK: - UI Variables
	
	private lazy var runChartView: UIView = {
		let view = UIView()
		view.layer.backgroundColor = UIColor.red.cgColor
		return view
	}()
	
	private lazy var averagePaceLabel: UILabel = UILabel.valueLabel()
	
	private lazy var averagePaceDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Avg Pace")
	
	private lazy var distanceLabel: UILabel = UILabel.valueLabel()
	
	private lazy var distanceDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Distance")
	
	private lazy var durationLabel: UILabel = UILabel.valueLabel()
	
	private lazy var durationDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Duration")
	
	private lazy var elevationLabel: UILabel = UILabel.valueLabel()
	
	private lazy var elevationDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Elevation")
	
	private lazy var heartRateLabel: UILabel = UILabel.valueLabel(color: .red)
	
	private lazy var heartRateDescriptionLabel: UILabel = UILabel.descriptionLabel(with: "Avg Heart Rate")
	
	private lazy var estimatedCaloriesLabel: UILabel = UILabel.valueLabel()
	
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
	
	
	
	// MARK: - Variables
	
	@objc dynamic private var run: Run!
	
	private var runObservers: [NSKeyValueObservation] = []
	
	
	
	// MARK: - Lifecyle Methods
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		title = run.displayTitle
		
		setupObservers()
    }
	
	override func loadView() {
		view = UIView()
		view.layer.backgroundColor = UIColor.white.cgColor
		
		[runChartView, wholeStackView].forEach {
			view.addSubview($0)
		}
		
		runChartView.snp.makeConstraints { (make) in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			make.leading.equalTo(view.snp.leading).inset(21)
			make.trailing.equalTo(view.snp.trailing).inset(21)
			make.height.equalTo(50)
		}
		
		wholeStackView.snp.makeConstraints { (make) in
			make.top.equalTo(runChartView.snp.bottom).inset(-5)
			make.leading.equalTo(runChartView.snp.leading)
			make.trailing.equalTo(runChartView.snp.trailing)
			make.bottom.lessThanOrEqualTo(view.snp.bottom).inset(5)
		}
	}
	
	
	
	// MARK: - Observers
	
	private func setupObservers() {
		runObservers = [
			self.observe(\RunDetailViewController.run?.averagePace, options: [.initial], changeHandler: { (object, _) in
				object.averagePaceLabel.text = "\(object.run.averagePace)"
			}),
			self.observe(\RunDetailViewController.run?.distance, options: [.initial], changeHandler: { (object, _) in
				object.averagePaceLabel.text = "\(object.run.distance)"
			}),
			self.observe(\RunDetailViewController.run?.duration, options: [.initial], changeHandler: { (object, _) in
				object.averagePaceLabel.text = "\(object.run.duration)"
			}),
			self.observe(\RunDetailViewController.run?.elevation, options: [.initial], changeHandler: { (object, _) in
				object.averagePaceLabel.text = "\(object.run.elevation)"
			}),
			self.observe(\RunDetailViewController.run?.averageHeartRate, options: [.initial], changeHandler: { (object, _) in
				object.averagePaceLabel.text = "\(object.run.averageHeartRate)"
			}),
			self.observe(\RunDetailViewController.run?.estimatedCalories, options: [.initial], changeHandler: { (object, _) in
				object.averagePaceLabel.text = "\(object.run.estimatedCalories)"
			})
		]
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
