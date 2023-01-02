//

import Foundation

public extension PersianDatePicker {
	
	struct Configuration {
		public var ui			: UIConfiguration
		public var texts		: TextsConfiguration
		public var selection	: SelectionConfiguration
		
		public init(minimumDate: Date, maximumDate: Date) {
			self.ui			= .init()
			self.texts		= .init()
			self.selection	= .init(minimumDate: minimumDate, maximumDate: maximumDate)
		}
		
	}
	
}

public extension PersianDatePicker.Configuration {
	
	struct UIConfiguration {
		
		internal static var shared = UIConfiguration()
		
		public var font							: UIFont	= .systemFont(ofSize: 16, weight: .regular)
		public var selectedDayTextColor			: UIColor	= .black
		public var selectedDayBackgroundColor	: UIColor	= #colorLiteral(red: 0, green: 0.8172753453, blue: 0.5961987972, alpha: 1)
	}
	
	struct TextsConfiguration {
		public var title	: String	= "تاریخ مورد نظر خود را انتخاب نمایید"
		public var message	: String?	= nil
        public var changeYearMonthTitle: String = "تغییر سال یا ماه"
        
		var hasMessage: Bool {
			return message != nil
		}
	}
	
	struct SelectionConfiguration {
		public var minimumDate				: Date
		public var maximumDate				: Date
		public var canSelectMultipleDates	: Bool
		public var preselectedDates			: [Date]
		public var defaultDay				: Date?
		
		init(minimumDate: Date, maximumDate: Date) {
			self.minimumDate			= minimumDate
			self.maximumDate			= maximumDate
			self.canSelectMultipleDates	= false
			self.preselectedDates		= []
			self.defaultDay				= nil
		}
		
	}
	
}
