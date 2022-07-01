//
//  BaseScreen.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 01.07.2022.
//

import Foundation

import UIKit

/// The base class for all screens.
/// All screens must subclass this class.
class BaseScreen: UIViewController {

	// MARK: - Private

	// MARK: Variables

	private var lifecycleListeners = [LifecycleListener]()

	// MARK: - Override

	// MARK: Functions

	override func viewDidLoad() {
		super.viewDidLoad()

		sendLifecycleEvent { $0.viewDidLoad() }
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		sendLifecycleEvent { $0.viewWillAppear() }
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		sendLifecycleEvent { $0.viewDidAppear() }
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		sendLifecycleEvent { $0.viewWillDisappear() }
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		sendLifecycleEvent { $0.viewDidDisappear() }
	}

	// MARK: - Public functions

	/// The method, which assigns accessibility identifiers,
	/// labels and values of UI components.
	 func setupAccessibility() {}

	func addLifecycleListener(_ lifecycleListener: LifecycleListener) {
		lifecycleListeners.append(lifecycleListener)
	}

}

// MARK: - Private functions

private extension BaseScreen {

	func sendLifecycleEvent(_ event: (LifecycleListener) -> Void) {
		lifecycleListeners.forEach { event($0) }
	}

}
