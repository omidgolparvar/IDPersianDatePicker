//
//  ViewController.swift
//  Example
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit
import PersianDatePicker

class ViewController: UIViewController {
	
	@IBOutlet weak var button_PresentDatePicker	: UIButton!
	
	private var preselectedDates: [Date] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		button_PresentDatePicker.layer.cornerRadius = 12.0
		
	}
	
	@IBAction func actionPresentPersianDatePicker(_ sender: UIButton) {
		let minimumDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
		let maximumDate = Calendar.current.date(byAdding: .day, value: 800, to: Date())!
		
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar(identifier: .persian)
		dateFormatter.locale = Locale(identifier: "en-us")
		dateFormatter.dateFormat = "yyyy/MM/dd EEEE"
		print("Min: " + dateFormatter.string(from: minimumDate))
		print("Max: " + dateFormatter.string(from: maximumDate))
		
		var config = PersianDatePicker.Configuration(
			minimumDate	: minimumDate,
			maximumDate	: maximumDate
		)
		config.ui.font = UIFont(name: "Vazir", size: 12)!
		config.texts.title = "انتخاب نمایید"
		config.texts.message = "تاریخ(های) مورد نظر خود را انتخاب کنین و بعدش دکمه تایید را بزنین"
		config.selection.canSelectMultipleDates = true
		config.selection.preselectedDates = preselectedDates
		
		PersianDatePicker.Present(
			sourceController	: self,
			configuration		: config,
			delegate			: self,
			completion			: nil
		)
		PersianDatePicker.Present(sourceController: <#T##UIViewController#>, configuration: <#T##PersianDatePicker.Configuration#>, delegate: <#T##PersianDatePickerDelegate#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
	}
	
}

extension ViewController: PersianDatePickerDelegate {
	
	func persianDatePicker(canSelectDate date: Date) -> Bool {
		return Calendar(identifier: .persian).component(.weekday, from: date) != 6
	}
	
	func persianDatePicker(didSelectDates dates: [Date]) {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar(identifier: .persian)
		dateFormatter.locale = Locale(identifier: "en-us")
		dateFormatter.dateFormat = "yyyy/MM/dd"
		
		print("Selected Dates:")
		dates.forEach {
			print(dateFormatter.string(from: $0))
		}
		
		preselectedDates = dates
	}
	
}



