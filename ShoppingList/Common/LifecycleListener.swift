//
//  LifecycleListener.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 01.07.2022.
//

import Foundation

/// Describes lifecycle functions and the contract between presenter and view.
protocol LifecycleListener: AnyObject {

	func viewDidLoad()

	func viewWillAppear()

	func viewDidAppear()

	func viewWillDisappear()

	func viewDidDisappear()

	/// The method called after the user tapped the back button of a navigation bar
	/// or when the user performed "swipe to dismiss" action.
	/// You can use this method to tell to the output that the module is being closed.
	func screenClosedByUser()

	/// The method called when a screen should be closed.
	func didAskToCloseScreen()

}

extension LifecycleListener {

	func viewDidLoad() {}

	func viewWillAppear() {}

	func viewDidAppear() {}

	func viewWillDisappear() {}

	func viewDidDisappear() {}

	func screenClosedByUser() {}

	func didAskToCloseScreen() {}

}
