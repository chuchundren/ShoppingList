//
//  Optional+Extension.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 30.01.2022.
//

import Foundation

extension Optional {

    // This property should be used instead of comparison with `nil` literal to decrease compilation time.
    var isNil: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }

}
