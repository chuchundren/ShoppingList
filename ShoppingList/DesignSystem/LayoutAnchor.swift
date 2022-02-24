//
//  LayoutAnchor.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 22.02.2022.
//

import UIKit

enum LayoutAnchor {
	case constant(attribute: NSLayoutConstraint.Attribute,
				  relation: NSLayoutConstraint.Relation,
				  constant: CGFloat)

	case relative(attribute: NSLayoutConstraint.Attribute,
				  relation: NSLayoutConstraint.Relation,
				  relatedTo: NSLayoutConstraint.Attribute,
				  multiplier: CGFloat,
				  constant: CGFloat)
}

// MARK: - Factory methods

// TODO: Add possibility to configure anchors relative to any other view

extension LayoutAnchor {

	static let leading = relative(attribute: .leading, relation: .equal, relatedTo: .leading)
	static let trailing = relative(attribute: .trailing, relation: .equal, relatedTo: .trailing)
	static let top = relative(attribute: .top, relation: .equal, relatedTo: .top)
	static let bottom = relative(attribute: .bottom, relation: .equal, relatedTo: .bottom)

	static let centerX = relative(attribute: .centerX, relation: .equal, relatedTo: .centerX)
	static let centerY = relative(attribute: .centerY, relation: .equal, relatedTo: .centerY)

	static let width = constant(attribute: .width, relation: .equal)
	static let height = constant(attribute: .height, relation: .equal)

	static func constant(
		attribute: NSLayoutConstraint.Attribute,
		relation: NSLayoutConstraint.Relation
	) -> (CGFloat) -> LayoutAnchor {
		return { constant in
				.constant(attribute: attribute, relation: relation, constant: constant)
		}
	}

	static func relative(
		attribute: NSLayoutConstraint.Attribute,
		relation: NSLayoutConstraint.Relation,
		relatedTo other: NSLayoutConstraint.Attribute,
		multiplier: CGFloat = 1
	) -> (CGFloat) -> LayoutAnchor {
		return { constant in
				.relative(attribute: attribute,
						  relation: relation,
						  relatedTo: other,
						  multiplier: multiplier,
						  constant: constant)
		}
	}

}

extension UIView {

	func addSubview(_ subview: UIView, anchors: [LayoutAnchor]) {
		subview.translatesAutoresizingMaskIntoConstraints = false
		addSubview(self)
		subview.activate(anchors: anchors, relativeTo: self)
	}

	func activate(anchors: [LayoutAnchor], relativeTo item: UIView? = nil) {
		let constraints = anchors.map {
			NSLayoutConstraint(from: self, to: item, anchor: $0)
		}

		NSLayoutConstraint.activate(constraints)
	}

}

extension NSLayoutConstraint {

	convenience init(from view: UIView, to other: UIView?, anchor: LayoutAnchor) {
		switch anchor {
		case let .constant(attribute, relation, constant):
			self.init(
				item: view,
				attribute: attribute,
				relatedBy: relation,
				toItem: nil,
				attribute: .notAnAttribute,
				multiplier: 1,
				constant: constant
			)
		case let .relative(attribute, relation, relatedTo, multiplier, constant):
			self.init(
				item: view,
				attribute: attribute,
				relatedBy: relation,
				toItem: other,
				attribute: relatedTo,
				multiplier: multiplier,
				constant: constant)
		}
	}

}
