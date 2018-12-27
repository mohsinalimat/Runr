//
//  Date+Extensions.swift
//  Runr
//
//  Created by Philip Sawyer on 12/26/18.
//  Copyright © 2018 Philip Sawyer. All rights reserved.
//

import Foundation

extension Date {
	
	/// Returns a string representing the day plus the time of day for this date
	///   - Example: "Saturday Afternoon"
	var dayPlusTimeOfDay: String {
		let calendar = Calendar.autoupdatingCurrent
		
		let dayIndex = calendar.component(.weekday, from: self)
		let day = calendar.weekdaySymbols[dayIndex]
		
		let hour = calendar.component(.hour, from: self)
		let timeOfDayString: String
		
		switch hour {
		case 0..<5:
			timeOfDayString = "Night"
		case 5..<12:
			timeOfDayString = "Morning"
		case 12..<17:
			timeOfDayString = "Afternoon"
		case 17..<21:
			timeOfDayString = "Evening"
		case 21..<24:
			timeOfDayString = "Night"
		default:
			return ""
		}
		
		return day + " " + timeOfDayString
	}
}
