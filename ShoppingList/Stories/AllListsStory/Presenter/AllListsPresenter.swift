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
	func openShoppingList(at index: Int)
}

protocol AllListsModuleInput {
	func updateList(_ list: ShoppingList)
}


class AllListsPresenter {
    
    private var shoppingLists: [ShoppingList] = []
	private var selectedIndex: Int?
    
    private unowned let view: AllListsScreen
    private var coordinator: AllListsModuleOutput?
    
    init(view: AllListsScreen, coordinator: AllListsModuleOutput) {
        self.view = view
        self.coordinator = coordinator
    }
	
	private func configureView() {
		 let viewModels = shoppingLists.map { list in
			ListCell.ViewModel(
				listTitle: list.title,
				description: " \(list.items.count) items"
			)
		}
		
		view.configure(with: viewModels)
	}
    
}

// MARK: - AllListsPresenterProtocol

extension AllListsPresenter: AllListsScreenOutput {
    
    func obtainLists() {

		defer {
			configureView()
		}
	
		guard shoppingLists.isEmpty else {
			return
		}
		
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
        
    }
    
    func didAddNewList(with title: String) {
        shoppingLists.insert(ShoppingList(title: title, items: []), at: 0)
        
        configureView()
		
		if let _ = shoppingLists.first {
			openShoppingList(at: 0)
		}
    }
	
	func openShoppingList(at index: Int) {
		coordinator?.openShoppingList(shoppingLists[index])
		selectedIndex = index
	}
    
}

// MARK: AllListsModuleInput

extension AllListsPresenter: AllListsModuleInput {
	func updateList(_ list: ShoppingList) {
		guard let index = selectedIndex else {
			return
		}
		
		shoppingLists[index] = list
		configureView()
	}
}
