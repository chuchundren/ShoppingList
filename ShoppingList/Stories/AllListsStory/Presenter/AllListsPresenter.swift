//
//  AllListsPresenter.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 08.12.2021.
//

import Foundation

protocol AllListsModuleInput: AnyObject {
    func reloadView()
}

class AllListsPresenter {
    
    private var shoppingLists: [ListCell.ViewModel] = []
    
    private unowned let view: ListScreen
    private var coordinator: AllListsModuleOutput?
	private var service: DataServiceAdapter
    
	init(view: ListScreen, coordinator: AllListsModuleOutput, service: DataServiceAdapter) {
        self.view = view
        self.coordinator = coordinator
		self.service = service
    }
    
    private func obtainLists() {
        shoppingLists = service.getViewModels()
        view.reloadCells(with: shoppingLists)
    }
    
}

extension AllListsPresenter: LifecycleListener {

	func viewDidAppear() {
		obtainLists()
	}
	
}

// MARK: - AllListsPresenterProtocol

extension AllListsPresenter: ListScreenOutput {}

extension AllListsPresenter: AllListsModuleInput {
    func reloadView() {
        shoppingLists = service.getViewModels()
        view.reloadCells(with: shoppingLists)
    }
}
