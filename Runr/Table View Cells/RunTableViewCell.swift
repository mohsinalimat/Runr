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
	
	weak var cache: NSCache<NSString, UIImage>?
	
	private lazy var runImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.layer.backgroundColor = UIColor.red.cgColor
		imageView.layer.cornerRadius = 14
		return imageView
	}()
	
	private lazy var runTitleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
		label.textAlignment = .left
		return label
	}()
	
	private lazy var distanceLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		label.textColor = UIColor.secondaryTextColor
		return label
	}()
	
	private lazy var averagePaceLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		label.textColor = UIColor.secondaryTextColor
		return label
	}()
	
	private lazy var disclosureImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage.disclosureIndicator)
		return imageView
	}()
	
	var run: Run? {
		didSet {
			guard let run = run else { return }
			self.runTitleLabel.text = run.displayTitle
			self.distanceLabel.text = "\(run.distance)"
			self.averagePaceLabel.text = "\(run.averagePace)"
			
			disclosureImageView.image = cache?.object(forKey: run.uuidString as NSString)
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		[runImageView, runTitleLabel, distanceLabel, averagePaceLabel, disclosureImageView].forEach {
			addSubview($0)
		}
		
		runImageView.snp.makeConstraints { (make) in
			make.top.equalTo(self.snp.top).inset(7)
			make.leading.equalTo(self.snp.leading).inset(7)
			make.bottom.equalTo(self.snp.bottom).inset(7)
			make.width.equalTo(self.runImageView.snp.height)
			make.width.equalTo(65)
		}
		
		runTitleLabel.snp.makeConstraints { (make) in
			make.top.equalTo(runImageView.snp.top).inset(12)
			make.leading.equalTo(runImageView.snp.trailing).inset(-16)
			make.trailing.lessThanOrEqualTo(disclosureImageView.snp.leading).inset(5)
		}
		
		distanceLabel.snp.makeConstraints { (make) in
			make.top.equalTo(runTitleLabel.snp.bottom).inset(-4)
			make.leading.equalTo(runTitleLabel.snp.leading)
			make.bottom.lessThanOrEqualTo(self.snp.bottom).inset(5)
		}
		
		averagePaceLabel.snp.makeConstraints { (make) in
			make.top.equalTo(distanceLabel.snp.top)
			make.leading.equalTo(distanceLabel.snp.trailing).inset(-25)
			make.trailing.lessThanOrEqualTo(disclosureImageView.snp.leading).inset(-5)
			make.bottom.equalTo(distanceLabel.snp.bottom)
		}
		
		disclosureImageView.snp.makeConstraints { (make) in
			make.centerY.equalTo(self.snp.centerY)
			make.trailing.equalTo(self.snp.trailing).inset(12)
			make.width.equalTo(8)
			make.height.equalTo(13)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
