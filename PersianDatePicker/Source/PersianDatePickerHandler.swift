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
	
	internal var areMinimumAndMaximumDatesInSameYear: Bool {
		let persianCalendar = Calendar.Persian
		let year_MinimumDate = persianCalendar.component(.year, from: delegate!.persianDatePicker_MinimumDate)
		let year_MaximumDate = persianCalendar.component(.year, from: delegate!.persianDatePicker_MaximumDate)
		return year_MinimumDate == year_MaximumDate
	}
	
	internal var areMinimumAndMaximumDatesInSameYearAndMonth: Bool {
		let persianCalendar = Calendar.Persian
		let month_MinimumDate = persianCalendar.component(.month, from: delegate!.persianDatePicker_MinimumDate)
		let month_MaximumDate = persianCalendar.component(.month, from: delegate!.persianDatePicker_MaximumDate)
		return self.areMinimumAndMaximumDatesInSameYear && (month_MinimumDate == month_MaximumDate)
	}
	
	internal var selectedDates_Array: [Date] {
		return Array(selectedDates_Set).sorted()
	}
	
	internal var currentYear_String: String {
		var dateComponents = DateComponents()
		dateComponents.year = currentYear
		let date = Calendar.Persian.date(from: dateComponents)!
		dateFormatter.dateFormat = "yyyy"
		let string = dateFormatter.string(from: date)
		return string
	}
	
	internal var currentMonth_String: String {
		var dateComponents = DateComponents()
		dateComponents.month = currentMonth
		let date = Calendar.Persian.date(from: dateComponents)!
		dateFormatter.dateFormat = "MMMM"
		let string = dateFormatter.string(from: date)
		return string
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
			if isSelected {
				currentPageDays[index] = .enableDate(date: date, isSelected: false)
				selectedDates_Set.remove(date)
			} else {
				currentPageDays[index] = .enableDate(date: date, isSelected: true)
				selectedDates_Set.insert(date)
			}
		default:
			return
		}
	}
	
	
	internal func gotoNextMonth() {
		
	}
	
	internal func gotoPreviousMonth() {
		
	}
	
	internal func gotoNextYear() {
		
	}
	
	internal func gotoPreviousYear() {
		
	}
	
	enum PresentingDay {
		case none
		case enableDate(date: Date, isSelected: Bool)
		case disableDate(Date)
	}
	
}
