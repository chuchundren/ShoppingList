//
//  AllListsPresenter.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 08.12.2021.
//

import Foundation

protocol AllListsScreenOutput {
    func obtainLists()
    func didAskToAddNewList(with title: String)
}

class AllListsPresenter {
    
    private var shoppingLists: [ListCell.ViewModel] = []
    
    private unowned let view: AllListsScreen
    private var coordinator: AllListsModuleOutput?
	private var service: DataServiceAdapter
    
	init(view: AllListsScreen, coordinator: AllListsModuleOutput, service: DataServiceAdapter) {
        self.view = view
        self.coordinator = coordinator
		self.service = service
    }
    
}

extension AllListsPresenter: LifecycleListener {

	func viewDidAppear() {
		obtainLists()
	}
	
}

// MARK: - AllListsPresenterProtocol

extension AllListsPresenter: AllListsScreenOutput {
    
    func obtainLists() {
		shoppingLists = service.getViewModels()
        view.configure(with: shoppingLists)
    }
    
    func didAskToAddNewList(with title: String) {
        coordinator?.didAskToAddNewList(with: title)
        shoppingLists = service.getViewModels()
        view.configure(with: shoppingLists)
    }
    
}
