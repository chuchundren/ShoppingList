//
//  SheetTransitionAnimation.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 10.05.2022.
//

import UIKit

final class SheetTransitionAnimation: NSObject {}

private extension SheetTransitionAnimation {

	func animatedShow(_ alertViewController: AddItemViewController,
					  using transitionContext: UIViewControllerContextTransitioning) {
		guard let view = alertViewController.view else {
			return
		}

		let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!) // Тот самый фрейм, который мы задали в PresentationController
		// Смещаем контроллер за границу экрана
		view.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
		let animator = UIViewPropertyAnimator(duration: Constants.animationDuration, curve: .easeOut) {
			view.frame = finalFrame // Возвращаем на место, так он выезжает снизу
		}

		animator.addCompletion { (position) in
			// Завершаем переход, если он не был отменён
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}

		animator.startAnimation()
	}

	func animateHide(_ alertViewController: AddItemViewController,
					 using transitionContext: UIViewControllerContextTransitioning) {
		guard let view = alertViewController.view else {
			return
		}

		let initialFrame = transitionContext.initialFrame(for: transitionContext.viewController(forKey: .from)!)

		let animator = UIViewPropertyAnimator(duration: Constants.animationDuration, curve: .easeOut) {
			view.frame = initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
		}

		animator.addCompletion { (position) in
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}

		animator.startAnimation()
	}

}


extension SheetTransitionAnimation: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		Constants.animationDuration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let fromVC = transitionContext.viewController(forKey: .from)
		let toVC = transitionContext.viewController(forKey: .to)

		if let sheetController = toVC as? AddItemViewController {
			animatedShow(sheetController, using: transitionContext)
		} else if let sheetController = fromVC as? AddItemViewController {
			animateHide(sheetController, using: transitionContext)
		}
	}

}

private extension SheetTransitionAnimation {

	struct Constants {
			static let animationDuration: TimeInterval = 0.25
		}

}
