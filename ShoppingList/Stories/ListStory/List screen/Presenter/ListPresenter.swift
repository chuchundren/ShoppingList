//
//  ListPresenter.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 18.11.2021.
//

import Foundation

protocol ListScreenOutput {
    func didSelectItem(at indexPath: IndexPath)
	func didAskToChangeTitle(newTitle: String)
	func didAskToAddNewItem()
	func didAskToDeleteList()
}

protocol ListModuleInput: AnyObject {
    func updateItem(_ item: Item)
    func deleteItem()
    func reload()
    func checkItem(id: String)
}

class ListPresenter {
    
    // MARK: - Private
    
    // MARK: Variables
    
    private unowned var view: ListScreen
    private var coordinator: ListModuleOutput
    private var service: DataServiceAdapter

    private var selectedIndexPath: IndexPath?
    private var items: [ListCell.ViewModel] = []
    
    // MARK: - Initialization
    
    init(view: ListScreen, coordinator: ListModuleOutput, service: DataServiceAdapter) {
        self.view = view
        self.coordinator = coordinator
        self.service = service
    }
}

extension ListPresenter: LifecycleListener {
    
    func viewDidAppear() {
        reloadView()
    }
}

// MARK: - ListPresenterProtocol

extension ListPresenter: ListScreenOutput {
    
    func didSelectItem(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
        coordinator.didSelectItem(at: indexPath.item)
    }
    
    func didAskToAddNewItem(_ item: Item) {
        coordinator.didAskToSaveNewItem(item)
        reloadView()
    }

	func didAskToChangeTitle(newTitle: String) {
        coordinator.didAskToChangeTitle(to: newTitle)
	}

	func didAskToAddNewItem() {
		coordinator.didAskToAddNewItem()
	}

	func didAskToDeleteList() {
        coordinator.didAskToDeleteList()
	}
	
}

// MARK: - ListModuleInput

extension ListPresenter: ListModuleInput {
    
    func updateItem(_ item: Item) {
        if let selectedIndex = selectedIndexPath {
            coordinator.didAskToUpdateItem(id: items[selectedIndex.row].id, newValue: item)
        }
    }
    
    func deleteItem() {
        if let selectedIndex = selectedIndexPath {
            coordinator.didAskToDeleteItem(id: items[selectedIndex.row].id)
        }
    }
    
    func reload() {
        reloadView()
    }
    
    func checkItem(id: String) {
        let index = items.firstIndex { item in
            item.id == id
        }
        
        items = service.getViewModels()
        
        if let index = index {
            view.reloadCell(at: IndexPath(row: index, section: 0), with: items[index])
        }
    }
	
}

// MARK: - Private methods

private extension ListPresenter {
    
    func reloadView() {
        items = service.getViewModels()
        view.configureCells(with: items)
    }
    
}
