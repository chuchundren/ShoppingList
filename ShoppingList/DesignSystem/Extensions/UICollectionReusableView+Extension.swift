//
//  UICollectionReusableView+Extension.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 07.02.2022.
//

import UIKit

protocol ReusableView {
	static var identifier: String { get }
}

extension ReusableView {
	
	static var identifier: String {
		String(describing: self)
	}
	
}

extension UICollectionReusableView: ReusableView {}

extension UITableViewCell: ReusableView {}
