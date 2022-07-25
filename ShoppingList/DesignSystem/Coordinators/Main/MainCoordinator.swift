//
//  MainCoordinator.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 28.11.2021.
//

import UIKit

class MainCoordinator: NavigationCoordinator {
    
    // MARK: - Private
    
    // MARK: UI
    
    private(set) weak var tabBarController: UITabBarController?
    
    private(set) lazy var coordinators: [NavigationCoordinator] = [
        AllListsCoordinator(),
        MainCoordinator.makeRecentListCoordinator(),
        ProfileCoordinator()
    ]

	// filter{ $0.createdAt.distance(to: Date()) < 60 * 60 * 24 * 7 }
    
    override func makeEntryPoint() -> UITabBarController {
        let tabBarController = makeTabBarController()
        tabBarController.selectedIndex = 1
        
        self.tabBarController = tabBarController
        
        return tabBarController
    }
    
}

// MARK: - Private functions

private extension MainCoordinator {
    
    func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = coordinators.map {
            $0.makeRootFlow()
        }
    
        tabBarController.tabBar.tintColor = .systemTeal
        tabBarController.tabBar.backgroundColor = .white
        
        return tabBarController
    }
    
    static func makeRecentListCoordinator() -> NavigationCoordinator {
        let dataManager = RealmDataManager.shared
        var list: ShoppingList
        
        if let recentlyBought = dataManager.shoppingList(withId: Constants.recentlyBoughtListId) {
            list = recentlyBought
        } else {
            let recentlyBought = ShoppingList(title: "Recently bought", id: Constants.recentlyBoughtListId, isRecentlyBoughtList: true)
            list = recentlyBought
            
            dataManager.save(recentlyBought)
        }
        
        return ListCoordinator(list: list)
    }
    
}

extension MainCoordinator {
    
    enum Tab {
        case allLists, list, userProfile
    }
}

extension UITabBarItem {
    
    func configure(tab: MainCoordinator.Tab) {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        let baselineOffset: CGFloat = 18
        
        titlePositionAdjustment.vertical = baselineOffset - 6
        // setTitleTextAttributes([.foregroundColor : UIColor.clear], for: .normal)
        
        switch tab {
        case .allLists:
            title = "All Lists"
            image = UIImage(systemName: "folder.fill")?
                .applyingSymbolConfiguration(imageConfig)?
                .withBaselineOffset(fromBottom: baselineOffset)
        case .list:
            title = "Recent"
            // This system image seems a bit heigher than it should be so I need to adjust the offset
            image =  UIImage(systemName: "checkmark.seal.fill")?
                .applyingSymbolConfiguration(imageConfig)?
                .withBaselineOffset(fromBottom: baselineOffset + 2)
        case .userProfile:
            title = "Profile"
            image = UIImage(systemName: "person.fill")?
                .applyingSymbolConfiguration(imageConfig)?
                .withBaselineOffset(fromBottom: baselineOffset)
        }
    }
    
}

// MARK: - Constants

private extension MainCoordinator {
    
    enum Constants {
        static let recentlyBoughtListId =  "recentlyBoughtList"
    }
    
}
