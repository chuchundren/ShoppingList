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
    
    func getViewModels() -> [ListCell.ViewModel] {
        if let list = service.shoppingList(withId: shoppingListId) {
            return list.items.enumerated().map { (_, item) in
                ListCell.ViewModel(item: item, check: check)
            }
        } else {
            let recentlyBought = ShoppingList(title: "Recently bought", id: shoppingListId, isRecentlyBoughtList: true)
            
            service.save(recentlyBought)
            return []
        }
    }
}
