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
				self.view_ContentHolder.backgroundColor = UIColor.SystemColors.secondarySystemFill
			} else if self.isSelected {
				self.view_ContentHolder.backgroundColor = UIConfiguration.shared.selectedDayBackgroundColor
			} else {
                self.view_ContentHolder.backgroundColor = UIColor.SystemColors.systemBackground
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
                : UIColor.SystemColors.systemBackground
			
			self.label_DateNumber.textColor = newValue
				? uiConfiguration.selectedDayTextColor
                : UIColor.SystemColors.label
			
			super.isSelected = newValue
		}
	}
	
	func setup(with day: PersianDatePicker.Manager.PageItem) {
		switch day {
		case .empty:
			view_ContentHolder.backgroundColor = .clear
			label_DateNumber.isHidden = true
		case .disableDate(let date):
            view_ContentHolder.backgroundColor = UIColor.SystemColors.systemBackground
			label_DateNumber.text = DayCell.CellDateFormatter.string(from: date)
            label_DateNumber.textColor = UIColor.SystemColors.tertiaryLabel
			label_DateNumber.isHidden = false
		case .enableDate(let date, let isSelected):
			let uiConfiguration = UIConfiguration.shared
			view_ContentHolder.backgroundColor = isSelected ? uiConfiguration.selectedDayBackgroundColor : UIColor.SystemColors.systemBackground
			label_DateNumber.text = DayCell.CellDateFormatter.string(from: date)
            label_DateNumber.textColor = isSelected ? uiConfiguration.selectedDayTextColor : UIColor.SystemColors.label
			label_DateNumber.isHidden = false
		}
	}
	
}

