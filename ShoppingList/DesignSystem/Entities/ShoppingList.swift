//
//  ShoppingList.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 08.12.2021.
//

import Foundation
import RealmSwift

final class ShoppingList: Object, ObjectKeyIdentifiable {
    
	@objc dynamic var title: String = ""
	@objc dynamic var id: String = ""
	@objc dynamic var isRecentlyBoughtList: Bool = false
	@objc dynamic let createdAt = Date()
	var items = RealmSwift.List<Item>()

	convenience init(title: String, id: String = UUID().uuidString, isRecentlyBoughtList: Bool = false) {
		self.init()
        self.title = title
        self.id = id
        self.isRecentlyBoughtList = isRecentlyBoughtList
    }

	override class func primaryKey() -> String? {
		"id"
	}

}
