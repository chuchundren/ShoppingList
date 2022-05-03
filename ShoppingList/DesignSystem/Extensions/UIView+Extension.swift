//
//  UIView+Extension.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 21.09.2021.
//

import UIKit

extension UIView {

	func top(equalTo item: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.topAnchor.constraint(equalTo: item, constant: constant)
	}
	func top(lessThanOrEqualTo item: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.topAnchor.constraint(lessThanOrEqualTo: item, constant: constant)
	}
	func top(greaterThanOrEqualTo item: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.topAnchor.constraint(greaterThanOrEqualTo: item, constant: constant)
	}

	func bottom(equalTo item: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.bottomAnchor.constraint(equalTo: item, constant: constant)
	}
	func bottom(lessThanOrEqualTo item: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.bottomAnchor.constraint(lessThanOrEqualTo: item, constant: constant)
	}
	func bottom(greaterThanOrEqualTo item: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.bottomAnchor.constraint(greaterThanOrEqualTo: item, constant: constant)
	}

	func leading(equalTo item: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.leadingAnchor.constraint(equalTo: item, constant: constant)
	}
	func leading(lessThanOrEqualTo item: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.leadingAnchor.constraint(lessThanOrEqualTo: item, constant: constant)
	}
	func leading(greaterThanOrEqualTo item: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.leadingAnchor.constraint(greaterThanOrEqualTo: item, constant: constant)
	}

	func trailing(equalTo item: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.trailingAnchor.constraint(equalTo: item, constant: constant)
	}
	func trailing(lessThanOrEqualTo item: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.trailingAnchor.constraint(lessThanOrEqualTo: item, constant: constant)
	}
	func trailing(greaterThanOrEqualTo item: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.trailingAnchor.constraint(greaterThanOrEqualTo: item, constant: constant)
	}

	func centerX(equalTo item: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.centerXAnchor.constraint(equalTo: item, constant: constant)
	}

	func centerY(equalTo item: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> NSLayoutConstraint {
		self.centerYAnchor.constraint(equalTo: item, constant: constant)
	}

}

extension UIView {
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

    }

	func addSubviews(_ subviews: UIView..., constraints: [NSLayoutConstraint]) {
		subviews.forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			addSubview($0)
		}

		NSLayoutConstraint.activate(constraints)
	}

    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
	
}

// MARK: - Layout

extension UIView {
    
    func pinToSuperview(insets: UIEdgeInsets? = nil) {
        if let parent = superview {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: parent.topAnchor),
                leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                bottomAnchor.constraint(equalTo: parent.bottomAnchor),
                trailingAnchor.constraint(equalTo: parent.trailingAnchor)
            ])
        }
    }
    
}

// MARK: - Animations

extension UIView {
    
    func shake(onCompletion: ((Bool) -> Void)? = nil) {
        let translation: CGFloat = 2.0
        let leftTranslation = transform.translatedBy(x: translation, y: 0.0)
        let rightTranslation = transform.translatedBy(x: -translation, y: 0.0)
        let originalTransform = transform

        transform = leftTranslation
        UIView.animate(withDuration: 0.07, delay: 0.0, options: []) {
            UIView.modifyAnimations(withRepeatCount: 5, autoreverses: true, animations: {
                self.transform = rightTranslation
            })
        } completion: { (completed) in
            self.transform = originalTransform
            onCompletion?(completed)
        }
    }
    
}

extension UIView {
    
    func addRoundedCorners(_ cornersToRound: UIRectCorner = .allCorners, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: cornersToRound,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
}
