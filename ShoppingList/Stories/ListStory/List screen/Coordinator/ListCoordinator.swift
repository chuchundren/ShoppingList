//
//  ListCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

protocol ListModuleOutput: AnyObject {
    func didSelectItem(at index: Int)
    func didAskToSaveNewItem(_ item: Item)
	func didAskToAddNewItem()
    func didAskToChangeTitle(to newTitle: String)
    func didAskToDeleteList()
    func didAskToUpdateItem(id: String, newValue: Item)
    func didAskToDeleteItem(id: String)
}

class ListCoordinator: NavigationCoordinator {
    private weak var presenter: ListModuleInput?
    private var list: ShoppingList
    private let dataManager: DataManager
    
    init(list: ShoppingList, dataManager: DataManager = RealmDataManager.shared) {
        self.list = list
        self.dataManager = dataManager
    }
    
    override func makeEntryPoint() -> UIViewController {
        let view = ListViewController()
        
        let service = ItemsDataServiceAdapter(
            service: dataManager,
            shoppingListId: list.id,
            check: list.isRecentlyBoughtList ? nil : checkItem
        )
        
        let presenter = ListPresenter(
            view: view,
            coordinator: self,
            service: service
        )
        
        self.presenter = presenter
        
        view.presenter = presenter
        view.addLifecycleListener(presenter)
        view.configureListNavBar(forRecent: list.isRecentlyBoughtList)
        view.tabBarItem.configure(tab: .list)
        view.title = list.title
       
        return view
    }
    
    func checkItem(id: String) {
        dataManager.toggleCheck(id: id)
        presenter?.checkItem(id: id)
    }
    
}

// MARK: - ListModuleOutput
    
extension ListCoordinator: ListModuleOutput {
    
    func didSelectItem(at index: Int) {
        let addNewItemCoordinator = EditItemCoordinator(item: list.items[index], output: self)
        open(child: addNewItemCoordinator)
    }
    
    func didAskToSaveNewItem(_ item: Item) {
        dataManager.save(item, into: list)
    }

	func didAskToAddNewItem() {
		let addItemCoordinator = AddItemCoordinator(output: self)
		let view = addItemCoordinator.makeEntryPoint()

		navigationController.present(view, animated: true)
	}
    
    func didAskToChangeTitle(to newTitle: String) {
        dataManager.updateListTitle(id: list.id, newTitle: newTitle)
    }
    
    func didAskToDeleteList() {
        dataManager.deleteObject(ofType: ShoppingList.self, withId: list.id)
    }
    
    func didAskToUpdateItem(id: String, newValue: Item) {
        dataManager.updateItem(withId: id, newValue: newValue)
    }
    
    func didAskToDeleteItem(id: String) {
        dataManager.deleteObject(ofType: Item.self, withId: id)
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

    func didAskToSaveItem(with title: String, quantity: Int) {
        let item = Item(title: title, isChecked: list.isRecentlyBoughtList, quantity: quantity)
        dataManager.save(item, into: list)
        
		presenter?.reload()
	}

}
