//
//  UserProfilePresenter.swift
//  ShoppingList
//
//  Created by Пальшау Дарья Денисовна [B] on 03.05.2022.
//

import Foundation
import UIKit

protocol ProfileScreenOutput {
	func didTapSettingsBarButton()
	
	func didTapSelectTimePeriodButton(sender: UIButton)
}

class ProfilePresenter {
	
	
	private unowned var view: ProfileScreen
	private var coordinator: ProfileModuleOutput
	
	init(view: ProfileScreen, coordinator: ProfileModuleOutput) {
		self.view = view
		self.coordinator = coordinator
	}
	
}

extension ProfilePresenter: ProfileScreenOutput {
	func didTapSettingsBarButton() {
		coordinator.openSettings()
	}
	
	func didTapSelectTimePeriodButton(sender: UIButton) {
		coordinator.openPopover(from: view, sender: sender)
	}
}
