//
//  Date.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

internal extension Date {
	
	static var Now: Date {
		return Date()
	}
	
	var startOfCurrentMonth: Date {
		let calendar = Calendar.Persian
		let components_StartOfMonth = calendar.dateComponents([.year, .month], from: self)
		let date_StartOfMonth = calendar.date(from: components_StartOfMonth)!
		return date_StartOfMonth
	}
	
	var endOfCurrentMonth: Date {
		let calendar = Calendar.Persian
		let components_StartOfMonth = calendar.dateComponents([.year, .month], from: self)
		let date_StartOfMonth = calendar.date(from: components_StartOfMonth)!
		var components = DateComponents()
		components.month = 1
		components.day = -1
		let data = calendar.date(byAdding: components, to: date_StartOfMonth)!
		return data
	}
	
	var startOfNextMonth: Date {
		let calendar = Calendar.Persian
		let components_StartOfMonth = calendar.dateComponents([.year, .month], from: self)
		let date_StartOfMonth = calendar.date(from: components_StartOfMonth)!
		var components = DateComponents()
		components.month = 1
		let data = calendar.date(byAdding: components, to: date_StartOfMonth)!
		return data
	}
	
	var startOfPreviousMonth: Date {
		let calendar = Calendar.Persian
		let components_StartOfMonth = calendar.dateComponents([.year, .month], from: self)
		let date_StartOfMonth = calendar.date(from: components_StartOfMonth)!
		var components = DateComponents()
		components.month = -1
		let data = calendar.date(byAdding: components, to: date_StartOfMonth)!
		return data
	}
	
	
}
