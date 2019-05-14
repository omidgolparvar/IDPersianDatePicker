//
//  DayCell.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
	
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
		let sharedDelegate = PersianDatePickerController.SharedDelegate!
		label_DateNumber.font = sharedDelegate.persianDatePicker_BaseFont.withSize(17)
    }
	
	override var isHighlighted: Bool {
		get {
			return super.isHighlighted
		}
		
		set {
			UIView.animate(withDuration: 0.2) { [weak self] in
				let isSelected = self?.isSelected ?? false
				if newValue {
					self?.view_ContentHolder.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
				} else if isSelected {
					self?.view_ContentHolder.backgroundColor = PersianDatePickerController.SharedDelegate!.persianDatePicker_SelectedDateColors.background
				} else {
					self?.view_ContentHolder.backgroundColor = .white
				}
			}
			
			super.isHighlighted = newValue
		}
	}
	
	override var isSelected: Bool {
		get {
			return super.isSelected
		}
		
		set {
			self.view_ContentHolder.backgroundColor = newValue ?
				PersianDatePickerController.SharedDelegate!.persianDatePicker_SelectedDateColors.background :
				.white
			self.label_DateNumber.textColor = newValue ?
				PersianDatePickerController.SharedDelegate!.persianDatePicker_SelectedDateColors.text :
				.black
			
			super.isSelected = newValue
		}
	}
	
	func setup(with day: PersianDatePickerHandler.PresentingDay) {
		switch day {
		case .none:
			self.isUserInteractionEnabled = false
			view_ContentHolder.backgroundColor = .clear
			label_DateNumber.isHidden = true
		case .disableDate(let date):
			self.isUserInteractionEnabled = false
			view_ContentHolder.backgroundColor = .white
			label_DateNumber.text = DayCell.CellDateFormatter.string(from: date)
			label_DateNumber.textColor = .lightGray
			label_DateNumber.isHidden = false
		case .enableDate(let date, let isSelected):
			let sharedDelegate = PersianDatePickerController.SharedDelegate!
			self.isUserInteractionEnabled = true
			view_ContentHolder.backgroundColor = isSelected ? sharedDelegate.persianDatePicker_SelectedDateColors.background : .white
			label_DateNumber.text = DayCell.CellDateFormatter.string(from: date)
			label_DateNumber.textColor = isSelected ? sharedDelegate.persianDatePicker_SelectedDateColors.text : .black
			label_DateNumber.isHidden = false
		}
	}
	
}
