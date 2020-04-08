//
//  NSAttributedString.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

internal extension NSAttributedString {
	
	static func Init(
		string			: String,
		font			: UIFont,
		textColor		: UIColor,
		textAlignment	: NSTextAlignment = .center) -> NSAttributedString {
		
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = textAlignment
		
		return NSAttributedString(string: string, attributes: [
			.font				: font,
			.foregroundColor	: textColor,
			.paragraphStyle		: paragraphStyle
			]
		)
	}
	
}
