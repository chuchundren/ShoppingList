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
    
    override func makeEntryPoint() -> UIViewController {
        let view = AllListsViewController()
        let presenter = AllListsPresenter(view: view, coordinator: self)
		
        view.presenter = presenter
		view.addLifecycleListener(presenter)
        view.tabBarItem.configure(tab: .allLists)
        
        return view
    }
    
}

extension AllListsCoordinator: AllListsModuleOutput {
    
    func openShoppingList(_ list: ShoppingList) {
        let coordinator = ListCoordinator(list: list)
        open(child: coordinator, navigationController: navigationController)
    }
}
