//
//  CustomButton.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit

internal class CustomButton: UIButton {

	internal override var isHighlighted: Bool {
		get {
			return super.isHighlighted
		}
		
		set {
			if newValue {
				backgroundColor = newValue ? #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1) : UIColor.white
				titleLabel?.alpha = newValue ? 0.3 : 1.0
			} else {
				UIView.animate(withDuration: 0.2) { [weak self] in
					self?.backgroundColor = newValue ? #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1) : UIColor.white
					self?.titleLabel?.alpha = newValue ? 0.3 : 1.0
				}
			}
			
			super.isHighlighted = newValue
		}
	}
}
