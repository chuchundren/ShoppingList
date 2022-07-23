//
//  GradientNavigationBarTitleTrait.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 05.02.2022.
//

import UIKit

protocol GradientNavigationBarTitleDisplayable {
    func configureGradient(in title: String?)
}

protocol GradientNavigationBarTitleTrait: UIViewController, GradientNavigationBarTitleDisplayable {}

extension GradientNavigationBarTitleTrait {
    
    func configureGradient(in title: String?) {
        if let navController = navigationController, let title = navigationItem.title, !title.isEmpty {
            let size = title.size(withAttributes: [.font : UIFont.systemFont(ofSize: 40.0, weight: .bold)])
            let bounds = CGRect(
                origin: navController.navigationBar.bounds.origin,
                size: CGSize(width: size.width, height: navController.navigationBar.bounds.height)
            )
            
            let colors = [UIColor.systemGreen, UIColor.systemTeal]
            let image = UIImage.gradientImage(bounds: bounds, colors: colors)
            let gradientColor = UIColor(patternImage: image)
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.largeTitleTextAttributes = [.foregroundColor: gradientColor]
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
}
