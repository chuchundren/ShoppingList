//
//  ListPresenter.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 18.11.2021.
//

import Foundation

protocol ListScreenOutput {}

protocol ListModuleInput: AnyObject {
    func updateItem(_ item: Item)
    func deleteItem()
    func reloadView()
    func checkItem(id: String)
    func configureTitle(_ title: String)
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

extension ListPresenter: ListScreenOutput {}

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
    
    func reloadView() {
        items = service.getViewModels()
        view.reloadCells(with: items)
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
    
    func configureTitle(_ title: String) {
        view.configureTitle(title)
    }
	
}
