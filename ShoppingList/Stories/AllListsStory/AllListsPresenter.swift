//
//  AllListsPresenter.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 08.12.2021.
//

import Foundation

protocol AllListsScreenOutput {
    func obtainLists()
    func didAddNewList(with title: String)
}

protocol AllListsModuleInput {
    func openShoppingList(at index: Int)
}


class AllListsPresenter {
    
    var shoppingLists: [ShoppingList] = []
    
    private unowned let view: AllListsScreen
    private var coordinator: AllListsModuleOutput?
    
    init(view: AllListsScreen, coordinator: AllListsModuleOutput) {
        self.view = view
        self.coordinator = coordinator
    }
    
}

// MARK: - AllListsPresenterProtocol

extension AllListsPresenter: AllListsScreenOutput {
    
    func obtainLists() {
        shoppingLists = [
            ShoppingList(
                title: "My shopping list",
                items: [
                    Item(title: "tofu"),
                    Item(title: "apples"),
                    Item(title: "cat food")
                ]
            ),
            
            ShoppingList(
                title: "Birthday party",
                items: [
                    Item(title: "cake"),
                    Item(title: "candles"),
                    Item(title: "pizza souce"),
                    Item(title: "dough")
                ]
            ),
            
            ShoppingList(
                title: "Weekly groceries",
                items: [
                    Item(title: "salat"),
                    Item(title: "mushrooms"),
                    Item(title: "eggs"),
                    Item(title: "pasta"),
                    Item(title: "broccoly"),
                    Item(title: "cheese")
                ]
            ),
        ]
        
        let viewModels = shoppingLists.map { list in
            ListCell.ViewModel(
                listTitle: list.title,
                description: " \(list.items.count) items"
            )
        }
        
        view.configure(with: viewModels)
    }
    
    func didAddNewList(with title: String) {
        shoppingLists.insert(ShoppingList(title: title, items: []), at: 0)
        
        let viewModels = shoppingLists.map { list in
            ListCell.ViewModel(
                listTitle: list.title,
                description: " \(list.items.count) items"
            )
        }
        
        view.configure(with: viewModels)
    }
    
}

// MARK: AllListsModuleInput

extension AllListsPresenter: AllListsModuleInput {
    
    func openShoppingList(at index: Int) {
        coordinator?.openShoppingList(shoppingLists[index])
    }
    
}
