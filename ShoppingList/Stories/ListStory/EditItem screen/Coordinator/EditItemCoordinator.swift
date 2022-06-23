//
//  EditItemCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 19.12.2021.
//

import UIKit

protocol EditItemModuleOutput: AnyObject {
    func didConfirmEditing(of item: Item)
    func didConfirmDeletion()
}

protocol EditItemCoordinatorOutput: AnyObject {
    func didFinishEditing(_ item: Item)
    func didDeleteItem()
}

class EditItemCoordinator: NavigationCoordinator {
    private weak var output: EditItemCoordinatorOutput?
    private var item: Item
    
    init(item: Item, output: EditItemCoordinatorOutput?) {
        self.item = item
        self.output = output
    }
    
    override func makeEntryPoint() -> UIViewController {
        let view = EditItemViewController()
        let presenter = EditItemPresenter(view: view, coordinator: self, item: item)
        view.presenter = presenter
        return view
    }
    
}

// MARK: - EditItemModuleOutput

extension EditItemCoordinator: EditItemModuleOutput {
    
    func didConfirmEditing(of item: Item) {
        output?.didFinishEditing(item)
        pop()
    }
    
    func didConfirmDeletion() {
        output?.didDeleteItem()
        pop()
    }
}
