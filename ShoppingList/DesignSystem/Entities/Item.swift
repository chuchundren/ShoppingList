//
//  Item.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 08.12.2021.
//

import UIKit
import RealmSwift

final class Item: Object, ObjectKeyIdentifiable {

	@objc dynamic var id = UUID().uuidString
	@objc dynamic var title: String = ""
	@objc dynamic var itemDescription: String? = ""
	@objc dynamic var isChecked: Bool = false
	@objc dynamic var quantity: Int = 1
	@objc dynamic var createdAt = Date()

    convenience init(title: String,
         description: String? = nil,
         isChecked: Bool = false,
         quantity: Int = 1) {
		self.init()
        self.title = title
        self.itemDescription = description
        self.isChecked = isChecked
        self.quantity = quantity
    }

	override class func primaryKey() -> String? {
		"id"
	}

}

struct ItemLabel {
    var title: String
    var color: UIColor

    static let healthy = Self(title: "healthy", color: .systemGreen)
    static let junk = Self(title: "junk", color: .systemRed)
    static let snack = Self(title: "snack", color: .purple)
    static let utilities = Self(title: "utilities", color: .cyan)
    static let other = Self(title: "other", color: .lightGray)
}
