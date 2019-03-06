//
//  PersianDatePickerController.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit

public class PersianDatePickerController: UIViewController {
	
	internal static weak var SharedDelegate: PersianDatePickerDelegate? = nil
	
	@IBOutlet weak var view_ContentHolder			: UIView!
	
	@IBOutlet weak var view_TitleAndMessageHolder	: UIView!
	@IBOutlet weak var label_TitleAndMessage		: UILabel!
	
	@IBOutlet weak var view_MonthChangerHolder		: UIView!
	@IBOutlet weak var label_YearAndMonth			: UILabel!
	@IBOutlet weak var button_PreviousMonth			: UIButton!
	@IBOutlet weak var button_NextMonth				: UIButton!
	
	@IBOutlet weak var stackView_WeekdayIdentifiers	: UIStackView!
	
	@IBOutlet weak var collectionView_Days			: UICollectionView!
	
	@IBOutlet weak var button_Select				: UIButton!
	
	internal weak var delegate	: PersianDatePickerDelegate!
	private var handler			: PersianDatePickerHandler!
	
	public override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
		setupHandler()
    }
	
	@IBAction func action_Button_NextMonth() {
		guard handler.canGoToNextMonth else { return }
		handler.gotoNextMonth()
		setupViews_ForNewCalendarPage()
	}
	
	@IBAction func action_Button_PreviousMonth() {
		guard handler.canGoToPreviousMonth else { return }
		handler.gotoPreviousMonth()
		setupViews_ForNewCalendarPage()
	}
	
	@IBAction func action_Button_SelectAndDismiss() {
		let _delegate = delegate
		let _dates = handler.selectedDates_Array
		dismiss(animated: true) {
			_delegate?.persianDatePicker_DidSelectDates(_dates)
		}
	}
	
}

extension PersianDatePickerController: UIGestureRecognizerDelegate {
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		if	let touchedView = touch.view,
			let gestureView = gestureRecognizer.view,
			touchedView.isDescendant(of: gestureView),
			touchedView !== gestureView {
			return false
		}
		return true
	}
	
}

extension PersianDatePickerController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return handler.currentPageDays.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView_Days.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
		cell.setup(with: handler.currentPageDays[indexPath.row])
		return cell
	}
	
	public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		actionToggleSelectionForItem(at: indexPath.row)
	}
	
	public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		actionToggleSelectionForItem(at: indexPath.row)
	}
	
	public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let frame_CollectionView = collectionView.frame
		let width: CGFloat = (frame_CollectionView.width - CGFloat(8)) / 7.0
		let height: CGFloat = (frame_CollectionView.height - CGFloat(5)) / 6.0
		let size = CGSize(width: width, height: height)
		return size
	}
	
}

internal extension PersianDatePickerController {
	
	private func setupViews() {
		setupViews_OtherViews()
		setupViews_Label_TitleAndMessage()
		setupViews_CollectionView_Days()
	}
	
	private func setupViews_OtherViews() {
		self.view.backgroundColor = .clear
		view_ContentHolder.layer.cornerRadius = 12.0
		
		button_NextMonth.layer.cornerRadius = button_NextMonth.frame.height / 2.0
		button_PreviousMonth.layer.cornerRadius = button_PreviousMonth.frame.height / 2.0
		
		let view_ButtonHolder = button_Select.superview!
		view_ButtonHolder.layer.cornerRadius = 12.0
		view_ButtonHolder.clipsToBounds = true
		button_Select.isEnabled = false
		button_Select.titleLabel?.font = delegate.persianDatePicker_BaseFont.withSize(18).boldVersion ?? UIFont.systemFont(ofSize: 18, weight: .bold)
		
		label_YearAndMonth.font = delegate.persianDatePicker_BaseFont.withSize(14)
		
		stackView_WeekdayIdentifiers.arrangedSubviews
			.compactMap { $0 as? UILabel }
			.forEach { $0.font = delegate.persianDatePicker_BaseFont.withSize(10) }
		
		let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.actionDismiss))
		tap.delegate = self
		self.view.addGestureRecognizer(tap)
	}
	
	private func setupViews_Label_TitleAndMessage() {
		let attributedText_Final = NSMutableAttributedString(string: "")
		
		let title = delegate.persianDatePicker_Title
		let attributedText_Title = NSAttributedString.Init(title,
			font		: delegate.persianDatePicker_BaseFont.withSize(18).boldVersion ?? UIFont.systemFont(ofSize: 18, weight: .bold),
			textColor	: .black
		)
		attributedText_Final.append(attributedText_Title)
		
		if let message = delegate.persianDatePicker_Message {
			let attributedText_Message = NSAttributedString.Init(message,
				font		: delegate.persianDatePicker_BaseFont.withSize(12.0),
				textColor	: .darkGray
			)
			
			attributedText_Final.append(NSAttributedString(string: "\n"))
			attributedText_Final.append(attributedText_Message)
		}
		
		label_TitleAndMessage.attributedText = attributedText_Final
	}
	
	private func setupViews_CollectionView_Days() {
		let nibFile_DayCell = UINib(nibName: "DayCell", bundle: Bundle.PersianDatePicker)
		collectionView_Days.register(nibFile_DayCell, forCellWithReuseIdentifier: "DayCell")
		collectionView_Days.backgroundColor = .groupTableViewBackground
		collectionView_Days.delegate = self
		collectionView_Days.dataSource = self
		collectionView_Days.semanticContentAttribute = .forceRightToLeft
		collectionView_Days.allowsMultipleSelection = true
	}
	
	private func setupViews_BasedOnHandler(isAnimated: Bool = false) {
		if isAnimated {
			UIView.transition(with: label_YearAndMonth, duration: 0.2, options: [.transitionFlipFromTop], animations: {
				self.label_YearAndMonth.text = self.handler.currentYearAndMonth_String
			}, completion: nil)
		} else {
			label_YearAndMonth.text = handler.currentYearAndMonth_String
		}
		button_NextMonth.isEnabled = handler.canGoToNextMonth
		button_PreviousMonth.isEnabled = handler.canGoToPreviousMonth
	}
	
	private func setupViews_ForNewCalendarPage() {
		setupViews_BasedOnHandler(isAnimated: true)
		collectionView_Days.reloadData()
	}
	private func setupHandler() {
		self.handler = PersianDatePickerHandler(delegate: delegate)
		setupViews_BasedOnHandler()
	}
	
	private func actionToggleSelectionForItem(at index: Int) {
		let day = handler.currentPageDays[index]
		guard case .enableDate(_, _) = day else { return }
		handler.toggleSelection(forDateAtIndex: index)
		button_Select.isEnabled = !handler.selectedDates_Array.isEmpty
	}
	
	@objc
	private func actionDismiss() {
		PersianDatePickerController.SharedDelegate = nil
		dismiss(animated: true, completion: nil)
	}
}
