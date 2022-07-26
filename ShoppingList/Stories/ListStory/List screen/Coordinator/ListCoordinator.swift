//
//  ListCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

protocol ListModuleOutput: AnyObject {
    func didAskToSaveNewItem(_ item: Item)
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
        ) { [weak self] item in
            self?.select(item)
        }
        
        let presenter = ListPresenter(
            view: view,
            coordinator: self,
            service: service
        )
        
        self.presenter = presenter
        
        view.presenter = presenter
        view.addLifecycleListener(presenter)
        view.tabBarItem.configure(tab: .list)
        view.title = list.title
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonTapped))
        let actionButton = list.isRecentlyBoughtList ? UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(recentListActionButtonTapped)
        ) : UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(actionButtonTapped)
        )
        
        view.navigationItem.rightBarButtonItems = [plusButton, actionButton]
       
        return view
    }
    
}

// MARK: - ListModuleOutput
    
extension ListCoordinator: ListModuleOutput {
    
    func didAskToSaveNewItem(_ item: Item) {
        dataManager.save(item, into: list)
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

private extension ListCoordinator {
    
    func checkItem(id: String) {
        dataManager.toggleCheck(id: id)
        presenter?.checkItem(id: id)
    }
    
    func select(_ item: Item) {
        let addNewItemCoordinator = EditItemCoordinator(item: item, output: self)
        open(child: addNewItemCoordinator)
    }
    
    func presentChangeTitleAlert() {
        let alert = UIAlertController(title: "Enter new title", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                if let title = alert.textFields?.first?.text {
                    guard let self = self else { return }
                    
                    self.dataManager.updateListTitle(id: self.list.id, newTitle: title)
                    
                    self.presenter?.configureTitle(title)
                }
            }
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    func presentSheetController() {
        let addItemCoordinator = AddItemCoordinator(output: self)
        let view = addItemCoordinator.makeEntryPoint()

        navigationController.present(view, animated: true)
    }
    
    
    func presentActionSheet(actions: [UIAlertAction]) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for action in actions {
            ac.addAction(action)
        }
        
        navigationController.present(ac, animated: true)
    }
    
    func deleteAction() -> UIAlertAction {
        UIAlertAction(title: "Delete list", style: .destructive) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.dataManager.deleteObject(ofType: ShoppingList.self, withId: self.list.id)
            
            self.navigationController.popViewController(animated: true)
        }
    }
    
    func editAction() -> UIAlertAction {
        UIAlertAction(title: "Change list name", style: .default) { [weak self] _ in
            self?.presentChangeTitleAlert()
        }
    }
    
    func activityAction() -> UIAlertAction {
        UIAlertAction(title: "Share", style: .default) { [weak self] _ in
            let activityVC = UIActivityViewController(activityItems: [], applicationActivities: nil)
            self?.navigationController.present(activityVC, animated: true)
        }
    }
    
    func cancelAction() -> UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel)
    }
    
    @objc func addItemButtonTapped() {
        presentSheetController()
    }

    @objc func actionButtonTapped() {
        presentActionSheet(actions: [activityAction(), editAction(), deleteAction(), cancelAction()])
    }
    
    @objc func recentListActionButtonTapped() {
        presentActionSheet(actions: [activityAction(), cancelAction()])
    }
    
}
