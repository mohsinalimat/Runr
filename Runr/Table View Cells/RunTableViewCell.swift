//
//  RunTableCellView.swift
//  Runr
//
//  Created by Philip Sawyer on 12/22/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

import SnapKit

class RunTableViewCell: UITableViewCell {
	
	static var identifier: String {
		return "RunTableViewCellIdentifier"
	}
	
	private lazy var runImageView: UIImageView = UIImageView()
	
	private lazy var runTitleLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	private lazy var distanceLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	private lazy var averagePaceLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	var run: Run? {
		didSet {
			guard let run = run else { return }
			self.runTitleLabel.text = run.title
			self.distanceLabel.text = "\(run.distance)"
			self.averagePaceLabel.text = "\(run.averagePace)"
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		[runImageView, runTitleLabel, distanceLabel, averagePaceLabel].forEach {
			addSubview($0)
		}
		
		runImageView.snp.makeConstraints { (make) in
			make.top.equalTo(self.snp.top).inset(5)
			make.leading.equalTo(self.snp.leading).inset(5)
			make.bottom.equalTo(self.snp.bottom).inset(5)
			make.width.equalTo(self.runImageView.snp.height)
			make.width.equalTo(65)
		}
		
		runTitleLabel.snp.makeConstraints { (make) in
			make.top.equalTo(runImageView.snp.top)
			make.leading.equalTo(runImageView.snp.trailing).inset(5)
			make.trailing.lessThanOrEqualTo(self.snp.trailing).inset(-5)
		}
		
		distanceLabel.snp.makeConstraints { (make) in
			make.top.equalTo(runTitleLabel.snp.bottom).inset(5)
			make.leading.equalTo(runTitleLabel.snp.leading)
			make.bottom.equalTo(self.snp.bottom).inset(-5)
		}
		
		averagePaceLabel.snp.makeConstraints { (make) in
			make.top.equalTo(distanceLabel.snp.top)
			make.leading.equalTo(distanceLabel.snp.trailing).inset(5)
			make.trailing.lessThanOrEqualTo(self.snp.trailing).inset(-5)
			make.bottom.equalTo(distanceLabel.snp.bottom)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
