//
//  Encodable+Extensions.swift
//  Runr
//
//  Created by Philip Sawyer on 11/24/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation

extension Encodable {
	var data: Data? {
		return try? JSONEncoder().encode(self)
	}
}
