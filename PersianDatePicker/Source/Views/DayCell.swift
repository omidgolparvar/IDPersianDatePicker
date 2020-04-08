//
//  DayCell.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
	
	private typealias UIConfiguration = PersianDatePicker.Configuration.UIConfiguration
	
	private static var CellDateFormatter: DateFormatter = {
		var dateFormatter = DateFormatter()
		dateFormatter.calendar = .Persian
		dateFormatter.locale = .Farsi
		dateFormatter.dateFormat = "d"
		return dateFormatter
	}()
	
	@IBOutlet weak var view_ContentHolder	: UIView!
	@IBOutlet weak var label_DateNumber		: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		label_DateNumber.font = UIConfiguration.shared.font.withSize(17)
    }
	
	override var isHighlighted: Bool {
		get {
			return super.isHighlighted
		}
		
		set {
			if newValue {
				self.view_ContentHolder.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
			} else if self.isSelected {
				self.view_ContentHolder.backgroundColor = UIConfiguration.shared.selectedDayBackgroundColor
			} else {
				self.view_ContentHolder.backgroundColor = .white
			}
			
			super.isHighlighted = newValue
		}
	}
	
	override var isSelected: Bool {
		get {
			return super.isSelected
		}
		
		set {
			let uiConfiguration = UIConfiguration.shared
			
			self.view_ContentHolder.backgroundColor = newValue
				? uiConfiguration.selectedDayBackgroundColor
				: .white
			
			self.label_DateNumber.textColor = newValue
				? uiConfiguration.selectedDayTextColor
				: .black
			
			super.isSelected = newValue
		}
	}
	
	func setup(with day: PersianDatePicker.Manager.PageItem) {
		switch day {
		case .empty:
			view_ContentHolder.backgroundColor = .clear
			label_DateNumber.isHidden = true
		case .disableDate(let date):
			view_ContentHolder.backgroundColor = .white
			label_DateNumber.text = DayCell.CellDateFormatter.string(from: date)
			label_DateNumber.textColor = .lightGray
			label_DateNumber.isHidden = false
		case .enableDate(let date, let isSelected):
			let uiConfiguration = UIConfiguration.shared
			view_ContentHolder.backgroundColor = isSelected ? uiConfiguration.selectedDayBackgroundColor : .white
			label_DateNumber.text = DayCell.CellDateFormatter.string(from: date)
			label_DateNumber.textColor = isSelected ? uiConfiguration.selectedDayTextColor : .black
			label_DateNumber.isHidden = false
		}
	}
	
}

