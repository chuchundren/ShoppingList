//
//  NumberFormatter+Extension.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 03.02.2022.
//

import Foundation

extension NumberFormatter {
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = .autoupdatingCurrent
        return formatter
    }()
    
}
