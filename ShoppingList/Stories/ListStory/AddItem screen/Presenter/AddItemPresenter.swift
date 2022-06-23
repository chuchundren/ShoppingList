//
//  AddItemPresenter.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 04.06.2022.
//

import UIKit

protocol AddItemScreenOutput {
	func didAskToSaveNewItem(_ item: Item)
}

class AddItemPresenter {
	private unowned var view: AddItemViewController
	private var coordinator: AddItemModuleOutput

	init(view: AddItemViewController, coordinator: AddItemModuleOutput) {
		self.view = view
		self.coordinator = coordinator
	}

}

extension AddItemPresenter: AddItemScreenOutput {

	func didAskToSaveNewItem(_ item: Item) {
		coordinator.didAskToSaveNewItem(item)
	}

}
