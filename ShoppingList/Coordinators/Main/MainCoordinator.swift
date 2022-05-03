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
        ListCoordinator(
            list: ShoppingList(
                title: "Recently bought",
                items: [
                    Item(
                        title: "tofu",
                        description: "Very long description message just to test how layout of the cells in the previous screen will change and whether description label will cover price label or not",
                        price: 1.64
                    ),
                    Item(title: "spinach", description: "fresh only"),
                    Item(title: "pear"),
                    Item(title: "coffee beans", description: "Medium roast", price: 3.56),
                    Item(title: "mushrooms"),
                    Item(title: "pasta", price: 0.99)
                ].filter{ $0.createdAt.distance(to: Date()) < 60 * 60 * 24 * 7 },
                isRecentlyBoughtList: true
            )
        ),
        ProfileCoordinator()
    ]
    
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
