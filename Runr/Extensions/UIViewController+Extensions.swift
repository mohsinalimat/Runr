//
//  NSViewController+Extensions.swift
//  Runr
//
//  Created by Philip Sawyer on 10/7/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import UIKit

extension UIViewController {
	
	/// returns the class name. to be used for instantiating vc's from storyboard
	static var className: String {
		return String(describing: self)
	}
}
