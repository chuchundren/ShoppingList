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
	func openShoppingList(at index: Int)
}

class AllListsPresenter {
    
	private var shoppingLists: [ShoppingList] = []
    
    private unowned let view: AllListsScreen
    private var coordinator: AllListsModuleOutput?
	private var dataManager: DataManager
    
	init(view: AllListsScreen, coordinator: AllListsModuleOutput, dataManager: DataManager = RealmDataManager.shared) {
        self.view = view
        self.coordinator = coordinator
		self.dataManager = dataManager
    }
	
	private func configureView() {
		 let viewModels = shoppingLists.map { list in
			ListCell.ViewModel(list: list)
		}
		
		view.configure(with: viewModels)
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
		shoppingLists = dataManager.shoppingLists()
		configureView()
    }
    
    func didAskToAddNewList(with title: String) {
		let newList = ShoppingList(title: title)
		dataManager.save(newList)
		shoppingLists = dataManager.shoppingLists()
        
        configureView()

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.coordinator?.openShoppingList(newList)
		}
    }
	
	func openShoppingList(at index: Int) {
		coordinator?.openShoppingList(shoppingLists[index])
	}
    
}
