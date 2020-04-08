//

import Foundation

protocol PersianDatePickerFastPaginatorDataSource {
	func fastPaginatorAvailableYears() -> [Int]
	func fastPaginatorAvailableMonths(for year: Int) -> [Int]
}

extension PersianDatePicker {
	
	final class Manager {
		
		typealias SelectionConfiguration = PersianDatePicker.Configuration.SelectionConfiguration
		
		private var dateFormatter		: DateFormatter = {
			let formatter = DateFormatter()
			formatter.locale	= .Farsi
			formatter.calendar	= .Persian
			return formatter
		}()
		
		private let minimumDate					: Date
		private let maximumDate					: Date
		private let canSelectMultipleDates		: Bool
		
		private weak var datePickerDelegate		: PersianDatePickerDelegate!
		
		private var selectedDates				: Set<Date>
		private var currentPageDateComponents	: DateComponents
		private var currentPageItems			: [PageItem]
		
		var selectedDatesIsEmpty: Bool {
			return selectedDates.isEmpty
		}
		
		var numberOfSelectedItems: Int {
			return selectedDates.count
		}
		
		var numberOfCurrentPageItems: Int {
			return currentPageItems.count
		}
		
		var sortedSelectedDates: [Date] {
			return Array(selectedDates).sorted()
		}
		
		var currentPageTitle: String {
			let date = Calendar.Persian.date(from: currentPageDateComponents)!
			dateFormatter.dateFormat = "MMMM  /  yyyy"
			let string = dateFormatter.string(from: date)
			return string
		}
		
		var FastPaginationIsAvailable: Bool {
			let persianCalendar = Calendar.Persian
			let minimumDate_Year = persianCalendar.component(.year, from: minimumDate)
			let maximumDate_Year = persianCalendar.component(.year, from: maximumDate)
			return (maximumDate_Year - minimumDate_Year) > 1
		}
		
		init(selectionConfiguration: SelectionConfiguration, delegate: PersianDatePickerDelegate) {
			self.datePickerDelegate			= delegate
			self.selectedDates				= Set<Date>()
			
			self.minimumDate				= selectionConfiguration.minimumDate
			self.maximumDate				= selectionConfiguration.maximumDate
			self.canSelectMultipleDates		= selectionConfiguration.canSelectMultipleDates
			
			self.currentPageDateComponents	= Calendar.Persian.dateComponents([.year, .month], from: minimumDate)
			self.currentPageItems			= []
			
			if selectionConfiguration.preselectedDates.isEmpty {
				if let defaultDay = selectionConfiguration.defaultDay {
					currentPageDateComponents = Calendar.Persian.dateComponents([.year, .month], from: defaultDay)
				}
			} else {
				let validDates = selectionConfiguration.preselectedDates
					.filter { minimumDate...maximumDate ~= $0 }
					.sorted()
				
				let firstValidDate = validDates.first!
				
				if selectionConfiguration.canSelectMultipleDates {
					validDates.forEach { selectedDates.insert($0) }
				} else {
					selectedDates.insert(firstValidDate)
				}
				
				currentPageDateComponents = Calendar.Persian.dateComponents([.year, .month], from: firstValidDate)
			}
			
			shouldGeneratePage()
		}
		
		func pageItem(at index: Int) -> PageItem {
			return currentPageItems[index]
		}
		
		func canPerformPagingAction(_ action: PagingAction) -> Bool {
			let currentYear		= currentPageDateComponents.year!
			let currentMonth	= currentPageDateComponents.month!
			
			switch action {
			case .next(.year):
				let nextYear			= currentYear + 1
				let maximumDate_Year	= Calendar.Persian.component(.year, from: maximumDate)
				return maximumDate_Year >= nextYear
				
			case .previous(.year):
				let previousYear		= currentYear - 1
				let minimumDate_Year	= Calendar.Persian.component(.year, from: minimumDate)
				return minimumDate_Year <= previousYear
				
			case .next(.month):
				let next_YearMonth: (year: Int, month: Int) = currentMonth == 12
					? (currentYear + 1, 1)
					: (currentYear, currentMonth + 1)
				
				let maximumDate_YearMonth = Calendar.Persian.dateComponents([.year, .month], from: maximumDate)
				
				if next_YearMonth.year < maximumDate_YearMonth.year! { return true }
				if next_YearMonth.year > maximumDate_YearMonth.year! { return false }
				
				return next_YearMonth.month <= maximumDate_YearMonth.month!
				
			case .previous(.month):
				let previous_YearMonth: (year: Int, month: Int) = currentMonth == 1
					? (currentYear - 1, 12)
					: (currentYear, currentMonth - 1)
				
				let minimumDate_YearMonth = Calendar.Persian.dateComponents([.year, .month], from: minimumDate)
				
				if previous_YearMonth.year < minimumDate_YearMonth.year! { return false }
				if previous_YearMonth.year > minimumDate_YearMonth.year! { return true }
				
				return previous_YearMonth.month >= minimumDate_YearMonth.month!
				
			case .present:
				#warning("اینجا رو باید پیاده‌سازی کنم")
				return true
			}
		}
		
		func performPagingAction(_ action: PagingAction) {
			guard canPerformPagingAction(action) else { return }
			
			var currentYear		= currentPageDateComponents.year!
			var currentMonth	= currentPageDateComponents.month!
			
			switch action {
			case .next(.month):
				if currentMonth == 12 {
					currentYear += 1
					currentMonth = 1
				} else {
					currentMonth += 1
				}
				
			case .previous(.month):
				if currentMonth == 1 {
					currentYear -= 1
					currentMonth = 12
				} else {
					currentMonth -= 1
				}
				
			case .next(.year):
				currentYear += 1
				
				let maximumDate_Month = Calendar.Persian.component(.month, from: maximumDate)
				if currentMonth > maximumDate_Month {
					currentMonth = maximumDate_Month
				}
				
			case .previous(.year):
				currentYear -= 1
				
				let minimumDate_Month = Calendar.Persian.component(.month, from: minimumDate)
				if currentMonth < minimumDate_Month {
					currentMonth = minimumDate_Month
				}
				
			case .present(let year, let month):
				currentYear = year
				currentMonth = month
				
			}
			
			currentPageDateComponents.year	= currentYear
			currentPageDateComponents.month	= currentMonth
			
			shouldGeneratePage()
		}
		
		func shouldGeneratePage() {
			currentPageItems.removeAll()
			
			let calendar = Calendar.Persian
			
			var dateComponents = currentPageDateComponents
			dateComponents.day = 1
			
			let tempDate				= calendar.date(from: dateComponents)!
			let startOfMonth			= tempDate.startOfCurrentMonth
			let endOfMonth				= tempDate.endOfCurrentMonth
			let startOfMonth_Weekday	= calendar.dateComponents([.weekday], from: startOfMonth).weekday!
			let numberOfDaysInMonth		= calendar.dateComponents([.day], from: endOfMonth).day!
			
			if startOfMonth_Weekday != 7 {
				for _ in 0..<startOfMonth_Weekday {
					currentPageItems.append(.empty)
				}
			}
			
			for value in 0..<numberOfDaysInMonth {
				let date = calendar.date(byAdding: .day, value: value, to: startOfMonth)!
				
				if	datePickerDelegate.persianDatePicker(canSelectDate: date),
					minimumDate...maximumDate ~= date {
					let isSelected	= selectedDates.contains(date)
					currentPageItems.append(.enableDate(date, isSelected: isSelected))
				} else {
					currentPageItems.append(.disableDate(date))
				}
			}
		}
		
		func toggleSelection(forDateAtIndex index: Int) {
			guard
				currentPageItems.count > index,
				case let .enableDate(date, isSelected) = currentPageItems[index]
				else { return }
			
			if isSelected {
				currentPageItems[index] = .enableDate(date, isSelected: false)
				selectedDates.remove(date)
			} else {
				currentPageItems[index] = .enableDate(date, isSelected: true)
				if canSelectMultipleDates {
					selectedDates.insert(date)
				} else {
					selectedDates.removeAll()
					selectedDates.insert(date)
				}
			}
		}
		
		
	}
	
}

extension PersianDatePicker.Manager: PersianDatePickerFastPaginatorDataSource {
	
	func fastPaginatorAvailableYears() -> [Int] {
		let persianCalendar = Calendar.Persian
		let minimumDate_Year = persianCalendar.component(.year, from: minimumDate)
		let maximumDate_Year = persianCalendar.component(.year, from: maximumDate)
		return Array(minimumDate_Year...maximumDate_Year)
	}
	
	func fastPaginatorAvailableMonths(for year: Int) -> [Int] {
		let persianCalendar = Calendar.Persian
		
		let minimumDate_YearMonth = persianCalendar.dateComponents([.year, .month], from: minimumDate)
		let maximumDate_YearMonth = persianCalendar.dateComponents([.year, .month], from: maximumDate)
		
		if year == minimumDate_YearMonth.year! {
			return Array(minimumDate_YearMonth.month!...12)
		}
		
		if year == maximumDate_YearMonth.year! {
			return Array(01...maximumDate_YearMonth.month!)
		}
		
		return Array(1...12)
	}
	
}

extension PersianDatePicker.Manager {
	
	enum PageItem {
		case empty
		case enableDate(Date, isSelected: Bool)
		case disableDate(Date)
	}
	
	enum PagingAction {
		case next(Element)
		case previous(Element)
		case present(year: Int, month: Int)
		
		enum Element {
			case year, month
		}
	}
	
}
