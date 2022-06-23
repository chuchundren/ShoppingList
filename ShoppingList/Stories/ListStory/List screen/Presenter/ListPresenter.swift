//
//  ListPresenter.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 18.11.2021.
//

import Foundation

protocol ListScreenOutput {
    var title: String { get }
    
    func obtainItems()
    func didSelectItem(at indexPath: IndexPath)
    func addItemWithTitle(_ title: String)
	func didReturnToPreviousScreen()
	func didAskToAddNewItem()
}

protocol ListModuleInput: AnyObject {
    func updateItem(_ item: Item)
    func deleteItem()
	func saveNewItem(_ item: Item)
}

class ListPresenter {
    
    // MARK: - Private
    
    // MARK: Variables
    
    private unowned var view: ListScreen
    private var coordinator: ListModuleOutput
    
    private var list: ShoppingList
    private var selectedIndexPath: IndexPath?
	
	var updateListsClosure: ((ShoppingList) -> Void)?
    
    // MARK: - Initialization
    
    init(view: ListScreen, coordinator: ListModuleOutput, list: ShoppingList) {
        self.view = view
        self.coordinator = coordinator
        self.list = list
    }
    
}

// MARK: - ListPresenterProtocol

extension ListPresenter: ListScreenOutput {
    
    var title: String {
        list.title
    }
    
    func obtainItems() {
        // TODO: Fetch objects from the persistant store
        reloadCells()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
        coordinator.didSelectItem(list.items[indexPath.item])
    }
    
    func didAskToAddNewItem(_ item: Item) {
        if list.isRecentlyBoughtList {
            var alreadyBoughtItem = item
            alreadyBoughtItem.isChecked = true
            
            list.items.insert(alreadyBoughtItem, at: 0)
        } else {
            list.items.insert(item, at: 0)
        }
        
        reloadCells()
    }
    
    func addItemWithTitle(_ title: String) {
        let item = Item(
            title: title,
            description: nil,
            label: nil,
            isChecked: false,
            quantity: 1,
            price: nil
        )
        
        list.items.insert(item, at: 0)
        reloadCells()
    }
    
	func didReturnToPreviousScreen() {
		updateListsClosure?(list)
	}

	func didAskToAddNewItem() {
		coordinator.didAskToAddNewItem()
	}
	
}

// MARK: - ListModuleInput

extension ListPresenter: ListModuleInput {
    
    func updateItem(_ item: Item) {
        if let selectedIndex = selectedIndexPath {
            list.items[selectedIndex.item] = item
            reloadCells()
        }
    }
    
    func deleteItem() {
        if let selectedIndex = selectedIndexPath {
            list.items.remove(at: selectedIndex.item)
            reloadCells()
        }
    }

	func saveNewItem(_ item: Item) {
		list.items.insert(item, at: 0)
		reloadCells()
	}
	
}

// MARK: - Private methods

private extension ListPresenter {
    
    func checkItem(at index: Int) {
        list.items[index].isChecked.toggle()
        reloadCells()
    }
    
    func reloadCells() {
        let models: [ListCell.ViewModel] = list.items.enumerated().map { (index, item) in
            var type: ListCell.ViewModel.ListCellType
            if list.isRecentlyBoughtList {
                if let price = item.price,
                   let formattedPrice = NumberFormatter.currencyFormatter.string(
                    from: NSNumber(value: price)
                   ) {
                    type = .recentItem(price: formattedPrice, quantity: item.quantity)
                } else {
                    type = .recentItem(price: "", quantity: item.quantity)
                }
            } else {
                type = .listItem(
                    quantity: item.quantity,
                    isChecked: item.isChecked,
                    onCheck: { [weak self] in
                        self?.checkItem(at: index)
                    }
                )
            }
            
            return ListCell.ViewModel(
                itemTitle: item.title,
                description: item.description,
                type: type
            )
        }
        
        view.configureCells(with: models)
    }
    
}
