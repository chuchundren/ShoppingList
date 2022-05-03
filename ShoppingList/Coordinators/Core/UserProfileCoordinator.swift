//
//  UserProfileCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

protocol ProfileModuleOutput: AnyObject {
	
	func openSettings()
	
	func openPopover(from controller: UIPopoverPresentationControllerDelegate,
					 sender: UIButton)
}

class ProfileCoordinator: NavigationCoordinator {
    
    override func makeEntryPoint() -> UIViewController {
        let view = ProfileViewController()
		let presenter = ProfilePresenter(view: view, coordinator: self)
		
		view.presenter = presenter
        view.tabBarItem.configure(tab: .userProfile)
        
        return view
    }
    
}

extension ProfileCoordinator: ProfileModuleOutput {
	func openSettings() {
		// Perform transition to settings screen
	}
	
	func openPopover(from controller: UIPopoverPresentationControllerDelegate,
					 sender: UIButton) {
		let popoverVC = TimePeriodPopover()
		popoverVC.modalPresentationStyle = .popover
		popoverVC.preferredContentSize = CGSize(width: 180, height: 220)
		
		let popover: UIPopoverPresentationController = popoverVC.popoverPresentationController!
		popover.delegate = controller
		popover.sourceView = sender
		popover.sourceRect = CGRect(x: sender.bounds.maxX, y: sender.bounds.midY, width: 0, height: 0)
		popover.permittedArrowDirections = [.left, .up]
		
		navigationController.present(popoverVC, animated: true)
	}
	
}
