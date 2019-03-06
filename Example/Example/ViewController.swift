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
	
	private let minimumDate: Date = {
		let date = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar(identifier: .persian)
		dateFormatter.locale = Locale(identifier: "en-us")
		dateFormatter.dateFormat = "yyyy/MM/dd EEEE"
		print("Min: " + dateFormatter.string(from: date))
		
		return date
	}()
	
	private let maximumDate: Date = {
		let date = Calendar.current.date(byAdding: .day, value: 20, to: Date())!
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar(identifier: .persian)
		dateFormatter.locale = Locale(identifier: "en-us")
		dateFormatter.dateFormat = "yyyy/MM/dd EEEE"
		print("Max: " + dateFormatter.string(from: date))
		
		return date
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		button_PresentDatePicker.layer.cornerRadius = 12.0
		
	}
	
	@IBAction func actionPresentPersianDatePicker(_ sender: UIButton) {
		PersianDatePickerController.Present(from: self, delegate: self)
	}
	
}

extension ViewController: PersianDatePickerDelegate {
	
	var persianDatePicker_BaseFont: UIFont {
		return UIFont(name: "Vazir", size: 12)!
	}
	
	var persianDatePicker_Title: String {
		return "انتخاب نمایید"
	}
	
	var persianDatePicker_Message: String? {
		return "تاریخ تولد خود را انتخاب کنین و بعدش دکمه تایید را بزنین"
	}
	
	var persianDatePicker_MinimumDate: Date {
		return minimumDate
	}
	
	var persianDatePicker_MaximumDate: Date {
		return maximumDate
	}
	
	func persianDatePicker_DidSelectDates(_ dates: [Date]) {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = Calendar(identifier: .persian)
		dateFormatter.locale = Locale(identifier: "en-us")
		dateFormatter.dateFormat = "yyyy/MM/dd"
		
		print("Selected Dates:")
		dates.forEach {
			print(dateFormatter.string(from: $0))
		}
	}
	
	func persianDatePicker_CanSelectDate(_ date: Date) -> Bool {
		let weekday = Calendar(identifier: .persian).component(.weekday, from: date)
		return weekday != 6
	}
	
}



