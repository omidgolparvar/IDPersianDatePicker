//
//  PersianDatePickerController.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import UIKit

class PersianDatePickerController: UIViewController {
	
	@IBOutlet weak var view_ContentHolder			: UIView!
	@IBOutlet weak var view_TitleAndMessageHolder	: UIView!
	@IBOutlet weak var label_TitleAndMessage		: UILabel!
	@IBOutlet weak var view_MonthChangerHolder		: UIView!
	@IBOutlet weak var button_YearAndMonth			: UIButton!
	@IBOutlet weak var button_PreviousMonth			: UIButton!
	@IBOutlet weak var button_NextMonth				: UIButton!
	@IBOutlet weak var button_PreviousYear			: UIButton!
	@IBOutlet weak var button_NextYear				: UIButton!
	@IBOutlet weak var stackView_WeekdayIdentifiers	: UIStackView!
	@IBOutlet weak var collectionView_Days			: UICollectionView!
	@IBOutlet weak var button_Select				: UIButton!
	
	private var configuration	: PersianDatePicker.Configuration!
	private weak var delegate	: PersianDatePickerDelegate?
	private var manager			: PersianDatePicker.Manager!
	
	convenience init(configuration: PersianDatePicker.Configuration, delegate: PersianDatePickerDelegate) {
		self.init(nibName: "PersianDatePickerController", bundle: .PersianDatePicker)
		
		self.configuration = configuration
		self.delegate = delegate
		
		self.manager = PersianDatePicker.Manager(selectionConfiguration: configuration.selection, delegate: delegate)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupViews()
    }
	
	@IBAction func action_Buttons_Paging(_ sender: UIButton) {
		let pagingAction: PersianDatePicker.Manager.PagingAction
		
		switch sender {
		case button_PreviousYear	: pagingAction = .previous(.year)
		case button_PreviousMonth	: pagingAction = .previous(.month)
		case button_NextMonth		: pagingAction = .next(.month)
		case button_NextYear		: pagingAction = .next(.year)
		default						: return
		}
		
		guard manager.canPerformPagingAction(pagingAction) else { return }
		manager.performPagingAction(pagingAction)
		setupViews_ForNewCalendarPage()
	}
	
	@IBAction func action_Button_SelectAndDismiss() {
		let _delegate = delegate
		let _dates = manager.sortedSelectedDates
		dismiss(animated: true) {
			_delegate?.persianDatePicker(didSelectDates: _dates)
		}
	}
	
	@IBAction func action_Button_ChangeYearAndMonth() {
		let changeYearAndMonthController = ChangeYearMonthController(dataSource: manager, delegate: self)
		
		let transitionDelegate = PersianDatePickerPresenter.TransitioningDelegate(customHeight: nil)
		changeYearAndMonthController.transitioningDelegate = transitionDelegate
		changeYearAndMonthController.modalPresentationStyle = .custom
		changeYearAndMonthController.modalPresentationCapturesStatusBarAppearance = true
		present(changeYearAndMonthController, animated: true, completion: nil)
	}
	
}

extension PersianDatePickerController: UIGestureRecognizerDelegate {
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
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
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return manager.numberOfCurrentPageItems
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let day = manager.pageItem(at: indexPath.row)
		let cell = collectionView_Days.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
		cell.setup(with: day)
		
		if case .enableDate(_, let isSelected) = day, isSelected {
			collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		actionToggleSelectionForItem(at: indexPath.row)
	}
	
	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		actionToggleSelectionForItem(at: indexPath.row)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let frame_CollectionView = collectionView.frame
		let width: CGFloat = (frame_CollectionView.width - CGFloat(8)) / 7.0
		let height: CGFloat = (frame_CollectionView.height - CGFloat(5)) / 6.0
		let size = CGSize(width: width, height: height)
		return size
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
		let day = manager.pageItem(at: indexPath.row)
		switch day {
		case .empty,
			 .disableDate:
			return false
		case .enableDate:
			return true
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
}

extension PersianDatePickerController: ChangeYearMonthDelegate {
	
	func changeYearMonthController(didSelectYear year: Int, andMonth month: Int) {
		manager.performPagingAction(.present(year: year, month: month))
		setupViews_ForNewCalendarPage()
	}
	
}

internal extension PersianDatePickerController {
	
	private func setupViews() {
		setupViews_OtherViews()
		setupViews_Label_TitleAndMessage()
		setupViews_CollectionView_Days()
		setupViews_BasedOnHandler()
	}
	
	private func setupViews_OtherViews() {
		let baseFont = configuration.ui.font
		self.view.backgroundColor = .clear
		view_ContentHolder.layer.cornerRadius = 12.0
		
		let pagingButtons: [UIView] = [button_PreviousYear, button_PreviousMonth, button_NextYear, button_NextMonth]
		pagingButtons.forEach {
			$0.layer.cornerRadius = 8
		}
		
		let view_ButtonHolder = button_Select.superview!
		view_ButtonHolder.layer.cornerRadius = 12.0
		view_ButtonHolder.clipsToBounds = true
		button_Select.isEnabled = false
		button_Select.titleLabel?.font = baseFont.withSize(18).boldVersion ?? baseFont.withSize(18)
		
		button_YearAndMonth.titleLabel?.font = baseFont.withSize(14)
		button_YearAndMonth.layer.cornerRadius = 8
		
		stackView_WeekdayIdentifiers.arrangedSubviews
			.compactMap { $0 as? UILabel }
			.forEach { $0.font = baseFont.withSize(10) }
		
		let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.actionDismiss))
		tap.delegate = self
		self.view.addGestureRecognizer(tap)
	}
	
	private func setupViews_Label_TitleAndMessage() {
		let baseFont = configuration.ui.font
		
		let attributedText_Final = NSMutableAttributedString()
		
		let title = configuration.texts.title + (configuration.texts.hasMessage ? "\n" : "")
		let attributedText_Title = NSAttributedString.Init(
			string		: title,
			font		: baseFont.withSize(18).boldVersion ?? baseFont.withSize(18),
			textColor	: .black
		)
		attributedText_Final.append(attributedText_Title)
		
		if let message = configuration.texts.message {
			let attributedText_Message = NSAttributedString.Init(
				string		: message,
				font		: baseFont.withSize(12.0),
				textColor	: .darkGray
			)
			
			attributedText_Final.append(attributedText_Message)
		}
		
		label_TitleAndMessage.attributedText = attributedText_Final
	}
	
	private func setupViews_CollectionView_Days() {
		let nibFile_DayCell = UINib(nibName: "DayCell", bundle: .PersianDatePicker)
		collectionView_Days.register(nibFile_DayCell, forCellWithReuseIdentifier: "DayCell")
		collectionView_Days.backgroundColor = .groupTableViewBackground
		collectionView_Days.delegate = self
		collectionView_Days.dataSource = self
		collectionView_Days.semanticContentAttribute = .forceRightToLeft
		collectionView_Days.allowsMultipleSelection = configuration.selection.canSelectMultipleDates
	}
	
	private func setupViews_SelectButton() {
		button_Select.isEnabled = !manager.selectedDatesIsEmpty
		
		if configuration.selection.canSelectMultipleDates {
			let numberOfSelectedItems = manager.numberOfSelectedItems
			let numberForamtter = NumberFormatter()
			numberForamtter.locale = .Farsi
			let string = numberForamtter.string(from: numberOfSelectedItems as NSNumber)!
			UIView.performWithoutAnimation {
				self.button_Select.setTitle("انتخاب \(string) مورد", for: .normal)
				self.button_Select.layoutIfNeeded()
			}
		}
	}
	
	private func setupViews_BasedOnHandler() {
		button_YearAndMonth.setTitle(manager.currentPageTitle, for: .normal)
		
		let buttonsConfig: [(button: UIButton, isEnabled: Bool)] = [
			(button_NextMonth		, manager.canPerformPagingAction(.next(.month))),
			(button_NextYear		, manager.canPerformPagingAction(.next(.year))),
			(button_PreviousMonth	, manager.canPerformPagingAction(.previous(.month))),
			(button_PreviousYear	, manager.canPerformPagingAction(.previous(.year)))
		]
		
		buttonsConfig.forEach {
			$0.button.isEnabled = $0.isEnabled
			$0.button.tintColor = $0.isEnabled ? self.view.tintColor : .lightGray
		}
		
		if !manager.FastPaginationIsAvailable {
			button_YearAndMonth.setTitleColor(.black, for: .disabled)
			button_YearAndMonth.backgroundColor = .white
			button_YearAndMonth.isEnabled = false
		}
		
		setupViews_SelectButton()
	}
	
	private func setupViews_ForNewCalendarPage() {
		setupViews_BasedOnHandler()
		collectionView_Days.reloadData()
	}
	
	private func actionToggleSelectionForItem(at index: Int) {
		let day = manager.pageItem(at: index)
		guard case .enableDate(_, let isSelected) = day else { return }
		manager.toggleSelection(forDateAtIndex: index)
		
		if isSelected {
			collectionView_Days.reloadItems(at: [.init(row: index, section: 0)])
		}
		
		setupViews_SelectButton()
	}
	
	@objc
	private func actionDismiss() {
		dismiss(animated: true, completion: nil)
	}
	
}
