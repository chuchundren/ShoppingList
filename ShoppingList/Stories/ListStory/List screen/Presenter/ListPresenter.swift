//
//  ListPresenter.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 18.11.2021.
//

import Foundation

protocol ListScreenOutput {
    var title: String { get }
	var isRecentlyBoughtList: Bool { get }
    
    func obtainItems()
    func didSelectItem(at indexPath: IndexPath)
	func didAskToChangeTitle(newTitle: String)
	func didAskToAddNewItem()
	func didAskToDeleteList()
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
	private var dataManager: DataManager
    
	private var list: ShoppingList
    private var selectedIndexPath: IndexPath?
    
    // MARK: - Initialization
    
	init(view: ListScreen, coordinator: ListModuleOutput, list: ShoppingList?, dataManager: DataManager = RealmDataManager.shared) {
        self.view = view
        self.coordinator = coordinator
		self.dataManager = dataManager

		if let list = list {
			self.list = list
		} else {
			if let recentlyBought = dataManager.shoppingList(withId: Constants.recentlyBoughtListId) {
				self.list = recentlyBought
			} else {
				let recentlyBought = ShoppingList(title: "Recently bought", id: Constants.recentlyBoughtListId, isRecentlyBoughtList: true)
				self.list = recentlyBought
				
				dataManager.save(recentlyBought)
			}
		}
    }
    
}

// MARK: - ListPresenterProtocol

extension ListPresenter: ListScreenOutput {
    
    var title: String {
        list.title
    }

	var isRecentlyBoughtList: Bool {
		list.isRecentlyBoughtList
	}
    
    func obtainItems() {
        // TODO: Fetch objects from the persistant store
        reloadView()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
        coordinator.didSelectItem(list.items[indexPath.item])
    }
    
    func didAskToAddNewItem(_ item: Item) {
        if list.isRecentlyBoughtList {
            let alreadyBoughtItem = item
            alreadyBoughtItem.isChecked = true
            
            list.items.insert(alreadyBoughtItem, at: 0)
        } else {
            list.items.insert(item, at: 0)
        }
        
        reloadView()
    }

	func didAskToChangeTitle(newTitle: String) {
		dataManager.updateListTitle(id: list.id, newTitle: newTitle)
	}

	func didAskToAddNewItem() {
		coordinator.didAskToAddNewItem()
	}

	func didAskToDeleteList() {
		dataManager.deleteObject(ofType: ShoppingList.self, withId: list.id)
	}
	
}

// MARK: - ListModuleInput

extension ListPresenter: ListModuleInput {
    
    func updateItem(_ item: Item) {
        if let selectedIndex = selectedIndexPath {
			dataManager.updateItem(withId: list.items[selectedIndex.row].id, newValue: item)
            reloadView()
        }
    }
    
    func deleteItem() {
        if let selectedIndex = selectedIndexPath {
			dataManager.deleteObject(ofType: Item.self, withId: list.items[selectedIndex.row].id)
            reloadView()
        }
    }

	func saveNewItem(_ item: Item) {
		dataManager.save(item, into: list)
		reloadView()
	}
	
}

// MARK: - Private methods

private extension ListPresenter {
    
    func checkItem(at index: Int) {
		dataManager.toggleCheck(list.items[index])

		let viewModel = mapViewModel(index: index, item: list.items[index])
		view.reloadCell(at: IndexPath(row: index, section: 0), with: viewModel)
    }
    
    func reloadView() {
        let models: [ListCell.ViewModel] = list.items.enumerated().map { (index, item) in
			mapViewModel(index: index, item: item)
        }
        
        view.configureCells(with: models)
    }

    func mapViewModel(index: Int, item: Item) -> ListCell.ViewModel {
        if isRecentlyBoughtList {
            return ListCell.ViewModel(item: item, check: nil)
        } else {
            return ListCell.ViewModel(item: item) { [weak self] in
                self?.checkItem(at: index)
            }
        }
	}
    
}

private extension ListPresenter {

	enum Constants {
		static let recentlyBoughtListId =  "recentlyBoughtList"
	}
}
