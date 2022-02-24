//
//  ListCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

protocol ListModuleOutput: AnyObject {
    func didSelectItem(_ item: Item)
}

class ListCoordinator: NavigationCoordinator {
    var presenter: ListModuleInput?
    var list: ShoppingList
    
    init(list: ShoppingList) {
        self.list = list
    }
    
    override func makeEntryPoint() -> UIViewController {
        let view = ListViewController()
        let presenter = ListPresenter(view: view, coordinator: self, list: list)
        self.presenter = presenter
        
        view.presenter = presenter
        view.tabBarItem.configure(tab: .list)
        
        return view
    }
    
}
    
extension ListCoordinator: ListModuleOutput {
    
    func didSelectItem(_ item: Item) {
        let addNewItemCoordinator = EditItemCoordinator(item: item, listOutput: self)

        // TODO: pass item to the coordinator
        
        open(child: addNewItemCoordinator, navigationController: navigationController)
    }
    
}

// MARK: - EditItemCoordinatorOutput

extension ListCoordinator: EditItemCoordinatorOutput {
    
    func didFinishEditing(_ item: Item) {
        presenter?.updateItem(item)
    }
    
    func didDeleteItem() {
        presenter?.deleteItem()
    }
    
}
