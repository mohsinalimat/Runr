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
	
	private var detailSubviewController: DetailSubViewController = {
		let detailSubView = DetailSubViewController.build()
		return detailSubView
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
		
		[runChartView, detailSubviewController.view].forEach {
			view.addSubview($0)
		}
		
		runChartView.snp.makeConstraints { (make) in
			make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			make.leading.equalTo(view.snp.leading).inset(21)
			make.trailing.equalTo(view.snp.trailing).inset(21)
			make.height.equalTo(50)
		}
		
		detailSubviewController.view.snp.makeConstraints { (make) in
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
				object.detailSubviewController.averagePaceLabel.text = "\(object.run.averagePace)"
			}),
			self.observe(\RunDetailViewController.run?.distance, options: [.initial], changeHandler: { (object, _) in
				object.detailSubviewController.averagePaceLabel.text = "\(object.run.distance)"
			}),
			self.observe(\RunDetailViewController.run?.duration, options: [.initial], changeHandler: { (object, _) in
				object.detailSubviewController.averagePaceLabel.text = "\(object.run.duration)"
			}),
			self.observe(\RunDetailViewController.run?.elevation, options: [.initial], changeHandler: { (object, _) in
				object.detailSubviewController.averagePaceLabel.text = "\(object.run.elevation)"
			}),
			self.observe(\RunDetailViewController.run?.averageHeartRate, options: [.initial], changeHandler: { (object, _) in
				object.detailSubviewController.averagePaceLabel.text = "\(object.run.averageHeartRate)"
			}),
			self.observe(\RunDetailViewController.run?.estimatedCalories, options: [.initial], changeHandler: { (object, _) in
				object.detailSubviewController.averagePaceLabel.text = "\(object.run.estimatedCalories)"
			})
		]
	}
}
