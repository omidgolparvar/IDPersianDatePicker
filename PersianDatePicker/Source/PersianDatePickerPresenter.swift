//
//  PersianDatePickerPresenter.swift
//  PersianDatePicker
//
//  Created by Omid Golparvar on 2/27/19.
//  Copyright © 2019 Omid Golparvar. All rights reserved.
//

import Foundation

internal final class PersianDatePickerPresenter {
	
	internal final class PresentingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
		
		func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
			guard let presentedViewController = transitionContext.viewController(forKey: .to) else { return }
			
			let containerView = transitionContext.containerView
			containerView.addSubview(presentedViewController.view)
			
			let finalFrameForPresentedView = transitionContext.finalFrame(for: presentedViewController)
			presentedViewController.view.frame = finalFrameForPresentedView
			presentedViewController.view.frame.origin.y = containerView.bounds.height
			
			UIView.animate(
				withDuration: transitionDuration(using: transitionContext),
				delay: 0,
				usingSpringWithDamping: 1,
				initialSpringVelocity: 1,
				options: .curveEaseOut,
				animations: {
					presentedViewController.view.frame = finalFrameForPresentedView
			}, completion: { finished in
				transitionContext.completeTransition(finished)
			})
		}
		
		func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
			return 0.6
		}
	}
	
	internal final class DismissingAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
		
		func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
			guard let presentedViewController = transitionContext.viewController(forKey: .from) else { return }
			
			let containerView = transitionContext.containerView
			let offscreenFrame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)
			
			UIView.animate(
				withDuration: transitionDuration(using: transitionContext),
				delay: 0,
				usingSpringWithDamping: 1,
				initialSpringVelocity: 1,
				options: .curveEaseIn,
				animations: {
					presentedViewController.view.frame = offscreenFrame
			}) { finished in
				transitionContext.completeTransition(finished)
			}
		}
		
		func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
			return 0.6
		}
	}
	
	internal final class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
		
		private var customHeight: CGFloat? = nil
		
		public init(customHeight: CGFloat?) {
			self.customHeight = customHeight
			
			if var height = self.customHeight {
				let extraForDismissButton: CGFloat = 80.0
				height += extraForDismissButton
				if	#available(iOS 11.0, *),
					let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom,
					bottomPadding > 24 {
					height += bottomPadding
				}
				self.customHeight = height + 10
			}
		}
		
		public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
			let controller = PresentationController(presentedViewController: presented, presenting: presenting)
			if let height = self.customHeight {
				controller.customHeight = height
			}
			return controller
		}
		
		public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
			return PresentingAnimationController()
		}
		
		public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
			return DismissingAnimationController()
		}
		
	}
	
	internal final class PresentationController: UIPresentationController {
		
		var customHeight: CGFloat? = nil
		
		private let backgroundView: UIView = UIView()
		
		override var frameOfPresentedViewInContainerView: CGRect {
			guard let containerView = containerView else { return .zero }
			
			var customHeight = self.customHeight ?? containerView.bounds.height
			if customHeight > containerView.bounds.height {
				customHeight = containerView.bounds.height
				print("Sheety: Custom height change to default value. Your height more maximum value")
			}
			
			let yOffset: CGFloat = containerView.bounds.height - customHeight
			
			if containerView.bounds.width >= 420 {
				return CGRect(
					x		: (containerView.bounds.width - 420.0) / 2.0,
					y		: yOffset,
					width	: 420,
					height	: containerView.bounds.height - yOffset
				)
			} else {
				return CGRect(
					x		: 0,
					y		: yOffset,
					width	: containerView.bounds.width,
					height	: containerView.bounds.height - yOffset
				)
			}
		}
		
		override func presentationTransitionWillBegin() {
			super.presentationTransitionWillBegin()
			
			guard
				let containerView = self.containerView,
				let window = containerView.window
				else { return }
			
			self.backgroundView.alpha = 0
			self.backgroundView.frame = .zero
			self.backgroundView.backgroundColor = .black
			self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
			
			containerView.insertSubview(self.backgroundView, belowSubview: presentedViewController.view)
			
			NSLayoutConstraint.activate([
				self.backgroundView.topAnchor.constraint(equalTo: window.topAnchor),
				self.backgroundView.leftAnchor.constraint(equalTo: window.leftAnchor),
				self.backgroundView.rightAnchor.constraint(equalTo: window.rightAnchor),
				self.backgroundView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
				])
			
			presentedViewController.transitionCoordinator?.animate(
				alongsideTransition: { [weak self] context in
					self?.backgroundView.alpha = 0.5
				},
				completion: nil
			)
		}
		
		override func presentationTransitionDidEnd(_ completed: Bool) {
			super.presentationTransitionDidEnd(completed)
			
			self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
			
			let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.dismissAction))
			tap.cancelsTouchesInView = false
			self.backgroundView.addGestureRecognizer(tap)
		}
		
		override func dismissalTransitionWillBegin() {
			super.dismissalTransitionWillBegin()
			presentedViewController.transitionCoordinator?.animate(
				alongsideTransition: { [weak self] context in
					guard let `self` = self else { return }
					self.backgroundView.alpha = 0
				},
				completion: { _ in
					
			}
			)
		}
		
		override func containerViewWillLayoutSubviews() {
			super.containerViewWillLayoutSubviews()
			
			guard let containerView = containerView else { return }
			
			if presentedViewController.view.isDescendant(of: containerView) {
				UIView.animate(withDuration: 0.1) { [weak self] in
					guard let `self` = self else { return }
					self.presentedViewController.view.frame = self.frameOfPresentedViewInContainerView
				}
			}
		}
		
		@objc
		private func dismissAction() {
			self.presentingViewController.view.endEditing(true)
			self.presentedViewController.view.endEditing(true)
			self.presentedViewController.dismiss(animated: true, completion: nil)
		}
	}

}
