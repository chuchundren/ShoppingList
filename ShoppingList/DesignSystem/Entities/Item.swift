//
//  Item.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 08.12.2021.
//

import UIKit

struct Item {
    
    let title: String
    let description: String?
    let label: ItemLabel?
    var isChecked: Bool
    var quantity: Int
    var price: Double?
    var createdAt: Date
    
    init(title: String,
         description: String? = nil,
         label: ItemLabel? = nil,
         isChecked: Bool = false,
         quantity: Int = 1,
         price: Double? = nil,
         createdAt: Date = Date()) {
        self.title = title
        self.description = description
        self.label = label
        self.isChecked = isChecked
        self.quantity = quantity
        self.price = price
        self.createdAt = createdAt
    }
    
}

struct ItemLabel {
    var title: String
    var color: UIColor
    
    static let healthy = Self(title: "healthy", color: .systemGreen)
    static let junk = Self(title: "junk", color: .systemRed)
    static let snack = Self(title: "snack", color: .purple)
    static let utilities = Self(title: "utilities", color: .cyan)
    static let other = Self(title: "other", color: .lightGray)
}
