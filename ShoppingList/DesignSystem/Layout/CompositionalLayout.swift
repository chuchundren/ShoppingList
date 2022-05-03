//
//  CompositionalLayout.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 29.01.2022.
//

import UIKit

struct CompositionalLayout {

    static func makeLayout() -> UICollectionViewCompositionalLayout {
        let header = makeUserHeader()
        let cardItem = makeCardCell()
        let cardGroup = makeRowGroup(with: cardItem)
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            switch section {
            case 0:
                return makeSection(with: cardGroup, supplementaryViews: [header])
            default:
                return nil
            }
        }
        
        return layout
    }
    
}

// MARK: - Private

private extension CompositionalLayout {
    
    // MARK: Builders
    
    // MARK: Headers
    
    static func makeUserHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(164)),
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    // MARK: Items
    
    static func makeCardCell() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(300)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        return item
    }
    
    // MARK: Groups
    
    
    static func makeRowGroup(with item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(200)
            ),
            subitems: [item]
        )
    }
    
    // MARK: Sections
    
    static func makeSection(with group: NSCollectionLayoutGroup,
                                supplementaryViews: [NSCollectionLayoutBoundarySupplementaryItem]? = nil) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        
        if let suppViews = supplementaryViews {
            section.boundarySupplementaryItems = suppViews
        }
        
        return section
    }
    
    
}


