//
//  RealmDataManager.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 29.06.2022.
//

import Foundation
import RealmSwift

class RealmDataManager: DataManager {
	
	private let realm: Realm? = {
		do {
			return try Realm()
		} catch {
			print(error)
			return nil
		}
	}()

	static let shared = RealmDataManager()

	func shoppingList(withId id: String) -> ShoppingList? {
		realm?.object(ofType: ShoppingList.self, forPrimaryKey: id)
	}

	func shoppingLists() -> [ShoppingList] {
		guard let results = realm?.objects(ShoppingList.self).filter({
			!$0.isRecentlyBoughtList
		}) else {
			return []
		}

		return Array(
			results
				.sorted { $0.createdAt > $1.createdAt}
				.filter { !$0.isRecentlyBoughtList }
		)
	}

	func save(_ item: Item, into list: ShoppingList) {
		write {
			list.items.insert(item, at: 0)
			realm?.add(list, update: .modified)
		}
	}

	func save(_ list: ShoppingList) {
		write {
			realm?.add(list, update: .modified)
		}
	}

	func deleteObject<T: Object>(ofType: T.Type, withId id: String) {
		guard let objectToDelete = realm?.object(ofType: T.self, forPrimaryKey: id) else {
			return
		}

		write {
			realm?.delete(objectToDelete)
		}
	}


	
	func updateItem(withId id: String, newValue: Item) {
		guard let item = realm?.object(ofType: Item.self, forPrimaryKey: id) else {
			return
		}

		write {
			item.title = newValue.title
			item.itemDescription = newValue.itemDescription
			item.quantity = newValue.quantity
			realm?.add(item, update: .modified)
		}
	}

	func updateList(withId id: String, newValue: ShoppingList) {
		guard let list = realm?.object(ofType: ShoppingList.self, forPrimaryKey: id) else {
			return
		}

		write {
			list.title = newValue.title
			realm?.add(list, update: .modified)
		}
	}

	func updateListTitle(id: String, newTitle: String)  {
		guard let list = realm?.object(ofType: ShoppingList.self, forPrimaryKey: id) else {
			return
		}

		write {
			list.title = newTitle
			realm?.add(list, update: .modified)
		}
	}


	func toggleCheck(_ item: Item) {
		write {
			item.isChecked.toggle()
			realm?.add(item, update: .modified)
		}
	}
    
    func toggleCheck(id: String) {
        guard let item = realm?.object(ofType: Item.self, forPrimaryKey: id) else {
            return
        }
        
        write {
            item.isChecked.toggle()
            realm?.add(item, update: .modified)
        }
    }

	private func write(writeClosure: () -> Void) {
		do {
			try realm?.write {
				writeClosure()
			}
		} catch {
			print(error)
		}
	}
}
