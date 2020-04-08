import Foundation

public extension PersianDatePicker {
	
	static func Present(
		sourceController	: UIViewController,
		configuration		: Configuration,
		delegate			: PersianDatePickerDelegate,
		completion			: (() -> Void)?) {
		
		PersianDatePicker.Configuration.UIConfiguration.shared = configuration.ui
		
		let datePickerController = PersianDatePickerController(
			configuration	: configuration,
			delegate		: delegate
		)
		
		let transitionDelegate = PersianDatePickerPresenter.TransitioningDelegate(customHeight: nil)
		datePickerController.transitioningDelegate = transitionDelegate
		datePickerController.modalPresentationStyle = .custom
		datePickerController.modalPresentationCapturesStatusBarAppearance = true
		sourceController.present(datePickerController, animated: true, completion: completion)
	}
	
}

