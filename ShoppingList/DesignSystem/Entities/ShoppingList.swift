//
//  ShoppingList.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 08.12.2021.
//

import Foundation

struct ShoppingList {
    
    var title: String
    var items: [Item]
    let isRecentlyBoughtList: Bool
    
    init(title: String, items: [Item], isRecentlyBoughtList: Bool = false) {
        self.title = title
        self.items = items
        self.isRecentlyBoughtList = isRecentlyBoughtList
    }
    
}
