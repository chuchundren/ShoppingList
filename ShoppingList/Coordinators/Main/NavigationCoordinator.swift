//
//  NavigationCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

class NavigationCoordinator {
    
    unowned var navigationController: UINavigationController!
    
    func makeEntryPoint() -> UIViewController {
        fatalError("Not implemented. Override `makeEntryPoint` in a subclass")
    }
    
    func makeRootFlow() -> UIViewController {
        let entryPoint = makeEntryPoint()
        
        let navigationController = UINavigationController(rootViewController: entryPoint)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        navigationController.view.backgroundColor = .clear
        
        self.navigationController = navigationController
        
        return navigationController
    }
    
    func open(child: NavigationCoordinator,
              navigationController: UINavigationController,
              animated: Bool = true) {
        let viewController = child.makeEntryPoint()
        child.navigationController = navigationController
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
