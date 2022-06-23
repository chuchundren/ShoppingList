//
//  AddItemCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 20.06.2022.
//

import UIKit


protocol AddItemModuleOutput {
	func didAskToSaveNewItem(_ item: Item)
}

protocol AddItemCoordinatorOutput: AnyObject {
	func didAskToSaveItem(_ item: Item)
}

final class AddItemCoordinator: NavigationCoordinator {
	private weak var output: AddItemCoordinatorOutput?
	var presenter: AddItemPresenter?

	init(output: AddItemCoordinatorOutput?) {
		self.output = output
	}

	override func makeEntryPoint() -> UIViewController {
		let view = AddItemViewController()
		let presenter = AddItemPresenter(view: view, coordinator: self)

		view.presenter = presenter
		view.modalPresentationStyle = .custom

		return view
	}

}

extension AddItemCoordinator: AddItemModuleOutput {

	func didAskToSaveNewItem(_ item: Item) {
		output?.didAskToSaveItem(item)
	}

}
