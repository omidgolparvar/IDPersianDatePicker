//
//  UIFont.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

internal extension UIFont {
	
	var boldVersion: UIFont? {
		guard let descriptorWithTraits = fontDescriptor.withSymbolicTraits(.traitBold) else { return nil }
		return UIFont(descriptor: descriptorWithTraits, size: self.pointSize)
	}
	
}
