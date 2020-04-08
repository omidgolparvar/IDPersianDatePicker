//
//  PersianDatePickerDelegate.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

public protocol PersianDatePickerDelegate: NSObjectProtocol {
	
	func persianDatePicker(canSelectDate date: Date) -> Bool
	func persianDatePicker(didSelectDates dates: [Date])
	
}

public extension PersianDatePickerDelegate {
	
	func persianDatePicker(canSelectDate date: Date) -> Bool {
		return true
	}
	
	
}


