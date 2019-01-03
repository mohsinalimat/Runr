//
//  RunningListViewController.swift
//  Runr
//
//  Created by Philip Sawyer on 10/7/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

class RunListViewController: UIViewController {
	
	class func build(runrController: RunrController, cacheController: CacheController) -> RunListViewController {
		let viewController = RunListViewController()
		viewController.runrController = runrController
		viewController.cacheController = cacheController
		return viewController
	}
	
	
	
	// MARK: - UI Variables
	
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.dataSource = self
		tableView.delegate = self
		tableView.layer.cornerRadius = 10
		return tableView
	}()
	
	
	
	// MARK: - Variables
	
	private var runrController: RunrController!
	
	private var cacheController: CacheController!
	
	
	
	// MARK: - Lifecyle Methods
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Runs"
		
		self.tableView.register(RunTableViewCell.self, forCellReuseIdentifier: RunTableViewCell.identifier)
	}
	
	override func loadView() {
		view = UIView()
		
		[tableView].forEach {
			view.addSubview($0)
		}
		
		tableView.snp.makeConstraints { (make) in
			make.top.equalTo(view.snp.top)
			make.leading.equalTo(view.snp.leading)
			make.trailing.equalTo(view.snp.trailing)
			make.bottom.equalTo(view.snp.bottom)
		}
	}
}



// MARK: - UITableViewDataSource and UITableViewDelegate

extension RunListViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return runrController.allRuns.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: RunTableViewCell.identifier, for: indexPath) as! RunTableViewCell
		let run = runrController.allRuns[indexPath.row]
		cell.cacheController = cacheController
		cell.run = run
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let run = runrController.allRuns[indexPath.row]
		let runDetailViewController = RunDetailViewController.build(with: run)
		navigationController?.pushViewController(runDetailViewController, animated: true)
		tableView.deselectRow(at: indexPath, animated: false)
	}
}
