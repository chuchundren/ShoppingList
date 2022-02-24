//
//  UserProfileCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

class UserProfileCoordinator: NavigationCoordinator {
    
    override func makeEntryPoint() -> UIViewController {
        let view = UserProfileViewController()
        view.tabBarItem.configure(tab: .userProfile)
        
        return view
    }
    
    
}
