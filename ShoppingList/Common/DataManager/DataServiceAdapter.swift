//
//  DataServiceAdapter.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 26.07.2022.
//

import Foundation

protocol DataServiceAdapter {
    func getViewModels() -> [ListCell.ViewModel]
}

struct ItemsDataServiceAdapter: DataServiceAdapter {
    let service: DataManager
    let shoppingListId: String
    let check: ((String) -> Void)?
    let select: (Item) -> Void
    
    func getViewModels() -> [ListCell.ViewModel] {
        if let list = service.shoppingList(withId: shoppingListId) {
            return list.items.enumerated().map { (_, item) in
                ListCell.ViewModel(item: item, check: check) {
                    select(item)
                }
            }
        } else {
            let recentlyBought = ShoppingList(title: "Recently bought", id: shoppingListId, isRecentlyBoughtList: true)
            
            service.save(recentlyBought)
            return []
        }
    }
}

struct ListsDataServiceAdapter: DataServiceAdapter {
    let service: DataManager
    let select: (ShoppingList) -> Void
    
    func getViewModels() -> [ListCell.ViewModel] {
        service.shoppingLists().map { list in
            ListCell.ViewModel(list: list) {
                select(list)
            }
        }
    }
}
