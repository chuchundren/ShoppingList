//
//  SupplementaryViewKind.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 30.01.2022.
//

import UIKit

/// Kind of reusable supplementary views in collection.
enum SupplementaryViewKind {
    
    case header
    case footer
    
    /// Returns string representation for case
    var rawValue: String {
        switch self {
        case .header:
            return UICollectionView.elementKindSectionHeader
        case .footer:
            return UICollectionView.elementKindSectionFooter
        }
    }
    
}
