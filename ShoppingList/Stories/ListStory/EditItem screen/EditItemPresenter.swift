//
//  EditItemPresenter.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 31.12.2021.
//

import Foundation

protocol EditItemScreenOutput {
    func viewDidLoad()
    func didFinishEditing(item: Item)
    func didTapDeleteButton()
}

protocol EditItemModuleInput {}

class EditItemPresenter {
    private unowned let view: EditItemScreen
    private let coordinator: EditItemModuleOutput
    private var item: Item
    
    init(view: EditItemScreen, coordinator: EditItemModuleOutput, item: Item) {
        self.view = view
        self.coordinator = coordinator
        self.item = item
    }
    
}

// MARK: - EditItemScreenOutput

extension EditItemPresenter: EditItemScreenOutput {
    
    func viewDidLoad() {
        view.configureView(with: item)
    }
    
    func didFinishEditing(item: Item) {
        coordinator.didConfirmEditing(of: item)
    }
    
    func didTapDeleteButton() {
        coordinator.didConfirmDeletion()
    }
}

// MARK: - EditItemModuleInput

extension EditItemPresenter: EditItemModuleInput {}
