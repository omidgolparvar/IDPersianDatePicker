import Foundation

public extension PersianDatePickerController {
	
	public static func Present(from sourceController: UIViewController, delegate: PersianDatePickerDelegate, completion: (() -> Void)? = nil) {
		
		let datePickerController = PersianDatePickerController(nibName: "PersianDatePickerController", bundle: .PersianDatePicker)
		datePickerController.delegate = delegate
		PersianDatePickerController.SharedDelegate = delegate
		
		#warning("باید ارتفاع مورد نیاز رو محاسبه کنم")
		
		let transitionDelegate = PersianDatePickerPresenter.TransitioningDelegate(customHeight: nil)
		datePickerController.transitioningDelegate = transitionDelegate
		datePickerController.modalPresentationStyle = .custom
		datePickerController.modalPresentationCapturesStatusBarAppearance = true
		sourceController.present(datePickerController, animated: true, completion: completion)
	}
	
}

