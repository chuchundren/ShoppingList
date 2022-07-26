//
//  AllListsCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

protocol AllListsModuleOutput: AnyObject {
    func didAskToAddNewList(with title: String)
}

class AllListsCoordinator: NavigationCoordinator {
    private let dataManager: DataManager
    
    init(dataManager: DataManager = RealmDataManager.shared) {
        self.dataManager = dataManager
    }
    
    override func makeEntryPoint() -> UIViewController {
        let view = AllListsViewController()
        let service = ListsDataServiceAdapter(service: dataManager) { [weak self] list in
            self?.select(list)
        }
        
        let presenter = AllListsPresenter(view: view, coordinator: self, service: service)
		
        view.presenter = presenter
		view.addLifecycleListener(presenter)
        view.configureNavigationBar()
        view.tabBarItem.configure(tab: .allLists)
        view.title = "All lists"
        
        return view
    }
    
    private func select(_ list: ShoppingList) {
        let coordinator = ListCoordinator(list: list)
        open(child: coordinator, navigationController: navigationController)
    }
    
}

extension AllListsCoordinator: AllListsModuleOutput {
    func didAskToAddNewList(with title: String) {
        let list = ShoppingList(title: title)
        dataManager.save(list)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.select(list)
        }
    }
}
