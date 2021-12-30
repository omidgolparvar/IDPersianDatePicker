//
//  PersianDatePickerController.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit

protocol ChangeYearMonthDelegate: NSObjectProtocol {
	func changeYearMonthController(didSelectYear year: Int, andMonth month: Int)
}

class ChangeYearMonthController: UIViewController {
	
	@IBOutlet weak var view_ContentHolder			: UIView!
	@IBOutlet weak var view_TitleAndMessageHolder	: UIView!
	@IBOutlet weak var label_TitleAndMessage		: UILabel!
	@IBOutlet weak var button_Select				: UIButton!
	@IBOutlet weak var pickerView_Main				: UIPickerView!
	
    private var configuration    : PersianDatePicker.Configuration!

	private let numberFormatter	: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.locale = .Farsi
		return formatter
	}()
	
	private let monthLabels		: [String] = {
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = .Persian
		dateFormatter.locale = .Farsi
		return dateFormatter.monthSymbols
	}()
	
	private weak var delegate		: ChangeYearMonthDelegate?
	private var dataSource		: PersianDatePickerFastPaginatorDataSource!
	
	private var availableYears	: [Int]	= []
	private var availableMonth	: [Int]	= []
	private var selectedYear	: Int	= -1
	private var selectedMonth	: Int	= -1
	
	convenience init(dataSource: PersianDatePickerFastPaginatorDataSource, delegate: ChangeYearMonthDelegate, configuration: PersianDatePicker.Configuration) {
		self.init(nibName: "ChangeYearMonthController", bundle: .PersianDatePicker)
		
		self.delegate	= delegate
		self.dataSource	= dataSource
		
		self.availableYears	= dataSource.fastPaginatorAvailableYears()
		self.selectedYear	= availableYears.first!
		
		self.availableMonth	= dataSource.fastPaginatorAvailableMonths(for: selectedYear)
		self.selectedMonth	= availableMonth.first!
        
        self.configuration = configuration
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		setupDataSources()
    }
	
	@IBAction func action_Button_SelectAndDismiss() {
		let _delegate = delegate
		let _selectedYear = selectedYear
		let _selectedMonth = selectedMonth
		dismiss(animated: true) {
			_delegate?.changeYearMonthController(didSelectYear: _selectedYear, andMonth: _selectedMonth)
		}
	}
	
}

extension ChangeYearMonthController: UIGestureRecognizerDelegate {
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		if	let touchedView = touch.view,
			let gestureView = gestureRecognizer.view,
			touchedView.isDescendant(of: gestureView),
			touchedView !== gestureView {
			return false
		}
		return true
	}
	
}

extension ChangeYearMonthController: UIPickerViewDataSource, UIPickerViewDelegate {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch component {
		case 1	: return availableYears.count
		case 0	: return availableMonth.count
		default	: fatalError("Invalid Component.")
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 44
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if component == 1 {
			let index = availableYears.index(of: selectedYear)!
			guard index != row else { return }
			selectedYear = availableYears[row]
			availableMonth = dataSource.fastPaginatorAvailableMonths(for: selectedYear)
			selectedMonth = availableMonth.first!
			pickerView.reloadComponent(0)
			pickerView.selectRow(0, inComponent: 0, animated: true)
		} else {
			selectedMonth = availableMonth[row]
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		
		let text: String
		switch component {
		case 1	: text = "سال \(numberFormatter.string(from: availableYears[row] as NSNumber)!)"
		case 0	: text = monthLabels[availableMonth[row]-1]
		default	: fatalError("Invalid Component.")
		}
		
		let label = view as? UILabel ?? UILabel()
		let baseFont = PersianDatePicker.Configuration.UIConfiguration.shared.font
		label.font = (baseFont.boldVersion ?? baseFont).withSize(18)
		label.textColor = .black
		label.text = text
		label.textAlignment = .center
		
		return label
	}
	
}

internal extension ChangeYearMonthController {
	
	private func setupViews() {
        let baseFont = configuration.ui.font
        let bottomSheetTitle = configuration.texts.changeYearMonthTitle
        
		self.view.backgroundColor = .clear
		view_ContentHolder.layer.cornerRadius = 12.0
		
		label_TitleAndMessage.font = (baseFont.boldVersion ?? baseFont).withSize(16)
        label_TitleAndMessage.text = bottomSheetTitle
        
		let view_ButtonHolder = button_Select.superview!
		view_ButtonHolder.layer.cornerRadius = 12.0
		view_ButtonHolder.clipsToBounds = true
		button_Select.titleLabel?.font = baseFont.withSize(18).boldVersion ?? baseFont.withSize(18)
		
		let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.actionDismiss))
		tap.delegate = self
		self.view.addGestureRecognizer(tap)
		
		pickerView_Main.backgroundColor = .white
		pickerView_Main.delegate = self
		pickerView_Main.dataSource = self
	}
	
	private func setupDataSources() {
		
	}
	
	@objc
	private func actionDismiss() {
		dismiss(animated: true, completion: nil)
	}
}
