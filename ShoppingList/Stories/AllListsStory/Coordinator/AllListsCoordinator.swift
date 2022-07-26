//
//  AllListsCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

protocol AllListsModuleOutput: AnyObject {}

class AllListsCoordinator: NavigationCoordinator {
    private let dataManager: DataManager
    private weak var presenter: AllListsModuleInput?
    
    init(dataManager: DataManager = RealmDataManager.shared) {
        self.dataManager = dataManager
    }
    
    override func makeEntryPoint() -> UIViewController {
        let view = AllListsViewController()
        let service = ListsDataServiceAdapter(service: dataManager) { [weak self] list in
            self?.select(list)
        }
        
        let presenter = AllListsPresenter(view: view, coordinator: self, service: service)
        self.presenter = presenter
		
        view.presenter = presenter
		view.addLifecycleListener(presenter)
        view.tabBarItem.configure(tab: .allLists)
        view.title = "All lists"
        
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newListButtonTapped))
        view.navigationItem.rightBarButtonItem = plusButton
        
        return view
    }
    
    
    // MARK: - Private methods
    
    private func select(_ list: ShoppingList) {
        let coordinator = ListCoordinator(list: list)
        open(child: coordinator, navigationController: navigationController)
    }
    
    private func presentNewListAlert() {
        let alert = UIAlertController(title: "New List", message: "Enter your new list's title.", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(
            UIAlertAction(title: "Add", style: .default) { [weak self] _ in
                if let title = alert.textFields?.first?.text, !title.isEmpty {
                    let list = ShoppingList(title: title)
                    self?.dataManager.save(list)
                    self?.presenter?.reloadView()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.select(list)
                    }
                    
                }
            }
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        navigationController.present(alert, animated: true)
    }

    @objc private func newListButtonTapped() {
        presentNewListAlert()
    }
    
}

extension AllListsCoordinator: AllListsModuleOutput {}
