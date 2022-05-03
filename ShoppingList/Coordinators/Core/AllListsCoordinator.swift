//
//  AllListsCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

protocol AllListsModuleOutput: AnyObject {
    func openShoppingList(_ list: ShoppingList)
}

class AllListsCoordinator: NavigationCoordinator {
	
	private var presenter: AllListsModuleInput?
    
    override func makeEntryPoint() -> UIViewController {
        let view = AllListsViewController()
        let presenter = AllListsPresenter(view: view, coordinator: self)
		self.presenter = presenter
		
        view.presenter = presenter
        view.tabBarItem.configure(tab: .allLists)
        
        return view
    }
    
}

extension AllListsCoordinator: AllListsModuleOutput {
    
    func openShoppingList(_ list: ShoppingList) {
        let coordinator = ListCoordinator(list: list)
		coordinator.allListsCoordinator = self
        open(child: coordinator, navigationController: navigationController)
    }
}

extension AllListsCoordinator: AllListsCoordinatorOutput {
	
	func updateList(_ list: ShoppingList) {
		presenter?.updateList(list)
	}
	
}
