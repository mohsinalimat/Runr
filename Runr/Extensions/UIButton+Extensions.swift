//
//  UIButton+Extensions.swift
//  Runr
//
//  Created by Philip Sawyer on 1/3/19.
//  Copyright © 2019 Philip Sawyer. All rights reserved.
//

import UIKit

extension UIButton {
	
	static var minusButton: UIButton {
		let button = UIButton()
		button.setImage(UIImage.minusButton, for: .normal)
		return button
	}
	
	static var addButton: UIButton {
		let button = UIButton()
		button.setImage(UIImage.addButton, for: .normal)
		return button
	}
}
