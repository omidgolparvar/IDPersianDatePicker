//
//  Bundle.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

internal extension Bundle {
	
	static var PersianDatePicker: Bundle {
		return Bundle(for: PersianDatePickerController.self)
	}
	
}
