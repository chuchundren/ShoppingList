//
//  NewItemSheetController.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 08.05.2022.
//

import UIKit

class SheetController: UIPresentationController {

	private lazy var dimmView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(white: 0, alpha: 0.3)
		view.alpha = 0
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeScreen))
		view.addGestureRecognizer(tapGesture)
		return view
	}()

	private var keyboardHeight: CGFloat?

	override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
		super.init(presentedViewController: presentedViewController, presenting: presentingViewController)


		NotificationCenter.default.addObserver(
			self,
			selector: #selector(adjustForKeyboard),
			name: UIResponder.keyboardWillChangeFrameNotification,
			object: nil
		)
	}

	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
			return
		}

		let keyboardFrame = keyboardValue.cgRectValue
		keyboardHeight = keyboardFrame.height

		presentedView?.frame = frameOfPresentedViewInContainerView
	}

	override var frameOfPresentedViewInContainerView: CGRect {
		let bounds = containerView!.bounds
		let height: CGFloat = 96

		guard let keyboardHeight = keyboardHeight else {
			return CGRect(x: 0,
						  y: bounds.height,
						  width: bounds.width,
						  height: height)
		}

		return CGRect(x: 0,
					  y: bounds.height - keyboardHeight - height,
					  width: bounds.width,
					  height: keyboardHeight + height)
	}

	override func presentationTransitionWillBegin() {
		super.presentationTransitionWillBegin()
		containerView?.addSubview(presentedView!)

		containerView?.insertSubview(dimmView, at: 0)
		performAlongsideTransitionIfPossible { [unowned self] in
				self.dimmView.alpha = 1
		}

	}

	override func presentationTransitionDidEnd(_ completed: Bool) {
		super.presentationTransitionDidEnd(completed)
		if !completed {
			self.dimmView.removeFromSuperview()
		}
	}

	override func dismissalTransitionWillBegin() {
		super.dismissalTransitionWillBegin()
		performAlongsideTransitionIfPossible { [unowned self] in
			self.dimmView.alpha = 0
		}
	}

	override func dismissalTransitionDidEnd(_ completed: Bool) {
		super.dismissalTransitionDidEnd(completed)
		if completed {
			self.dimmView.removeFromSuperview()
		}
	}


	override func containerViewDidLayoutSubviews() {
		super.containerViewDidLayoutSubviews()
		presentedView?.frame = frameOfPresentedViewInContainerView
		dimmView.frame = containerView!.frame
	}

	private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
		guard let coordinator = self.presentedViewController.transitionCoordinator else {
			block()
			return
		}

		coordinator.animate(alongsideTransition: { (_) in
			block()
		}, completion: nil)
	}

	@objc private func closeScreen() {
		presentedViewController.dismiss(animated: true)
	}

}
