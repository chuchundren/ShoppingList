//
//  DataManager.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 29.06.2022.
//

import Foundation
import RealmSwift

protocol DataManager {

	func shoppingList(withId id: String) -> ShoppingList?
	func shoppingLists() -> [ShoppingList]
	
	func save(_ list: ShoppingList)
	func save(_ item: Item, into list: ShoppingList)
	
	func deleteObject<T: Object>(ofType: T.Type, withId id: String)

	func updateItem(withId id: String, newValue: Item)
	func updateListTitle(id: String, newTitle: String)

	func toggleCheck(_ item: Item)
}
