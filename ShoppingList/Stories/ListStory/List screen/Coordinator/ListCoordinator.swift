//
//  ListCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

protocol ListModuleOutput: AnyObject {
    func didSelectItem(_ item: Item)
	func didAskToAddNewItem()
}

class ListCoordinator: NavigationCoordinator {
	weak var output: ListCoordinatorOutput?
	
    private weak var presenter: ListModuleInput?
    private var list: ShoppingList
    
    init(list: ShoppingList) {
        self.list = list
    }
    
    override func makeEntryPoint() -> UIViewController {
        let view = ListViewController()
        let presenter = ListPresenter(view: view, coordinator: self, list: list)
		presenter.updateListsClosure = { [weak self] list in
			self?.output?.updateList(list)
		}
		
        self.presenter = presenter
        
        view.presenter = presenter
        view.tabBarItem.configure(tab: .list)
        
        return view
    }
    
}

// MARK: - ListModuleOutput
    
extension ListCoordinator: ListModuleOutput {
    
    func didSelectItem(_ item: Item) {
        let addNewItemCoordinator = EditItemCoordinator(item: item, output: self)
        open(child: addNewItemCoordinator)
    }

	func didAskToAddNewItem() {
		let addItemCoordinator = AddItemCoordinator(output: self)
		let view = addItemCoordinator.makeEntryPoint()

		navigationController.present(view, animated: true)
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

// MARK: - AddItemCoordinatorOutput

extension ListCoordinator: AddItemCoordinatorOutput {

	func didAskToSaveItem(_ item: Item) {
		presenter?.saveNewItem(item)
	}

}
