//
//  PersianDatePickerDelegate.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

public protocol PersianDatePickerDelegate: NSObjectProtocol {
	
	var persianDatePicker_BaseFont					: UIFont { get }
	var persianDatePicker_Title						: String { get }
	var persianDatePicker_Message					: String? { get }
	var persianDatePicker_SelectedDateColor			: UIColor { get }
	var persianDatePicker_CanSelectMultipleDates	: Bool { get }
	
	func persianDatePicker_CanSelectDate(_ date: Date) -> Bool
	func persianDatePicker_DidSelectDates(_ dates: [Date])
	
	var persianDatePicker_MinimumDate	: Date { get }
	var persianDatePicker_MaximumDate	: Date { get }
}

public extension PersianDatePickerDelegate {
	
	public var persianDatePicker_Message: String? {
		return nil
	}
	
	public var persianDatePicker_CanSelectMultipleDates: Bool {
		return false
	}
	
	public var persianDatePicker_SelectedDateColor: UIColor {
		return #colorLiteral(red: 0, green: 0.8172753453, blue: 0.5961987972, alpha: 1)
	}
	
	public func persianDatePicker_CanSelectDate(_ date: Date) -> Bool {
		return true
	}
	
	
}


