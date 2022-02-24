//
//  UIColor+Extension.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 05.10.2021.
//

import UIKit

extension UIColor {
  
    convenience init(anyModeColor: UIColor, darkModeColor: UIColor) {
        self.init {
            $0.userInterfaceStyle == .dark ? darkModeColor : anyModeColor
        }
    }
    
}

/// App theme colors
extension UIColor {
    
    static let textMain = UIColor(
        anyModeColor: .black,
        darkModeColor: .white
    )
    
    static let textGrayLight = UIColor(red: 0.33, green: 0.38, blue: 0.44, alpha: 1)
    
    static let textGrayDark = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
    
    static let textGray = UIColor(
        anyModeColor: textGrayLight,
        darkModeColor: textGrayDark
    )
    
    static let bgLight = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
    
    static let bgDark = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    static let bg = UIColor(
        anyModeColor: bgLight,
        darkModeColor: bgDark
    )
    
}
