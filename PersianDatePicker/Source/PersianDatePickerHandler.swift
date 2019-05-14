//
//  PersianDatePickerHandler.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

internal final class PersianDatePickerHandler {
	
	private var dateFormatter		: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = Locale.Farsi
		formatter.calendar = Calendar.Persian
		return formatter
	}()
	
	private weak var delegate		: PersianDatePickerDelegate!
	private var selectedDates_Set	: Set<Date>
	private var currentYear			: Int!
	private var currentMonth		: Int!
	internal var currentPageDays	: [PresentingDay]!
	
	internal var selectedDates_Array: [Date] {
		return Array(selectedDates_Set).sorted()
	}
	
	internal var currentYearAndMonth_String: String {
		var dateComponents = DateComponents()
		dateComponents.year = currentYear
		dateComponents.month = currentMonth
		let date = Calendar.Persian.date(from: dateComponents)!
		dateFormatter.dateFormat = "MMMM  /  yyyy"
		let string = dateFormatter.string(from: date)
		return string
	}
	
	internal var canGoToNextMonth: Bool {
		var nextYearMonth: (year: Int, month: Int)
		if currentMonth == 12 {
			nextYearMonth = (currentYear + 1, 1)
		} else {
			nextYearMonth = (currentYear, currentMonth + 1)
		}
		let maximumDate = delegate.persianDatePicker_MaximumDate
		let maximumDateYearMonth: (year: Int, month: Int) = (
			Calendar.Persian.component(.year, from: maximumDate),
			Calendar.Persian.component(.month, from: maximumDate)
		)
		
		if nextYearMonth.year < maximumDateYearMonth.year { return true }
		if nextYearMonth.year > maximumDateYearMonth.year { return false }
		
		return nextYearMonth.month <= maximumDateYearMonth.month
	}
	
	internal var canGoToPreviousMonth: Bool {
		var previousYearMonth: (year: Int, month: Int)
		if currentMonth == 1 {
			previousYearMonth = (currentYear - 1, 12)
		} else {
			previousYearMonth = (currentYear, currentMonth - 1)
		}
		
		let minimumDate = delegate.persianDatePicker_MinimumDate
		let minimumDateYearMonth: (year: Int, month: Int) = (
			Calendar.Persian.component(.year, from: minimumDate),
			Calendar.Persian.component(.month, from: minimumDate)
		)
		
		if previousYearMonth.year < minimumDateYearMonth.year { return false }
		if previousYearMonth.year > minimumDateYearMonth.year { return true }
		
		return previousYearMonth.month >= minimumDateYearMonth.month
	}
	
	
	internal init(delegate: PersianDatePickerDelegate) {
		self.delegate			= delegate
		self.selectedDates_Set		= Set<Date>()
		self.currentPageDays	= []
		
		let calendar = Calendar.Persian
		let minimumDate = delegate.persianDatePicker_MinimumDate
		let dateComponents = calendar.dateComponents([.year, .month], from: minimumDate)
		currentYear = dateComponents.year!
		currentMonth = dateComponents.month!
		
		generateDays()
	}
	
	private func generateDays() {
		self.currentPageDays = []
		
		let calendar = Calendar.Persian
		var dateComponents = DateComponents()
		dateComponents.calendar = calendar
		dateComponents.year = currentYear
		dateComponents.month = currentMonth
		dateComponents.day = 1
		let tempDate = calendar.date(from: dateComponents)!
		let startOfCurrentMonth = tempDate.startOfCurrentMonth
		let endOfCurrentMonth = tempDate.endOfCurrentMonth
		let startOfCurrentMonth_Weekday = calendar.dateComponents([.weekday], from: startOfCurrentMonth).weekday!
		let numberOfDaysInCurrentMonth = calendar.dateComponents([.day], from: endOfCurrentMonth).day!
		
		if startOfCurrentMonth_Weekday != 7 {
			(0..<startOfCurrentMonth_Weekday).forEach { _ in
				currentPageDays.append(.none)
			}
		}
		
		let minimumDate = delegate.persianDatePicker_MinimumDate
		let maximumDate = delegate.persianDatePicker_MaximumDate
		
		(0..<numberOfDaysInCurrentMonth).forEach { value in
			var dateComponents = DateComponents()
			dateComponents.day = value
			let date = calendar.date(byAdding: dateComponents, to: startOfCurrentMonth)!
			let isSelected = selectedDates_Set.contains(date)
			let canSelect = delegate.persianDatePicker_CanSelectDate(date)
			let isInRange = (date >= minimumDate) && (date <= maximumDate)
			currentPageDays.append((canSelect && isInRange) ? .enableDate(date: date, isSelected: isSelected) : .disableDate(date))
		}
	}
	
	internal func toggleSelection(forDateAtIndex index: Int) {
		guard currentPageDays.count > index else { return }
		
		switch currentPageDays[index] {
		case .enableDate(let date, let isSelected):
			if delegate.persianDatePicker_CanSelectMultipleDates {
				if isSelected {
					currentPageDays[index] = .enableDate(date: date, isSelected: false)
					selectedDates_Set.remove(date)
				} else {
					currentPageDays[index] = .enableDate(date: date, isSelected: true)
					selectedDates_Set.insert(date)
				}
			} else {
				if isSelected {
					currentPageDays[index] = .enableDate(date: date, isSelected: false)
					selectedDates_Set.remove(date)
				} else {
					currentPageDays[index] = .enableDate(date: date, isSelected: true)
					selectedDates_Set.removeAll()
					selectedDates_Set.insert(date)
				}
			}
		default:
			return
		}
	}
	
	internal func gotoNextMonth() {
		if currentMonth == 12 {
			currentYear += 1
			currentMonth = 1
		} else {
			currentMonth += 1
		}
		
		generateDays()
	}
	
	internal func gotoPreviousMonth() {
		if currentMonth == 1 {
			currentYear -= 1
			currentMonth = 12
		} else {
			currentMonth -= 1
		}
		
		generateDays()
	}
	
	enum PresentingDay {
		case none
		case enableDate(date: Date, isSelected: Bool)
		case disableDate(Date)
	}
	
}
