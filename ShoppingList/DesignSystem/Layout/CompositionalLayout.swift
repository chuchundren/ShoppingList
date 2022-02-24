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
        let rowItem = makeRowCell()
        
        let cardGroup = makeCardGroup(with: cardItem)
        let rowGroup = makeRowGroup(with: rowItem)
        
        let layout = UICollectionViewCompositionalLayout { section, environment in
            switch section {
            case 0:
                return makeCardSection(with: cardGroup, supplementaryViews: [header])
            case 1:
                return makeCardSection(with: rowGroup)
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
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        return item
    }
    
    static func makeRowCell() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(80)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        return item
    }
    
    // MARK: Groups
    
    static func makeCardGroup(with item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(200)
            ),
            subitems: [item]
        )
    }
    
    static func makeRowGroup(with item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ),
            subitems: [item]
        )
    }
    
    // MARK: Sections
    
    static func makeCardSection(with group: NSCollectionLayoutGroup,
                                supplementaryViews: [NSCollectionLayoutBoundarySupplementaryItem]? = nil) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        
      //  let background = NSCollectionLayoutDecorationItem.background(elementKind: "background-element-kind")
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 8)
        section.orthogonalScrollingBehavior = .groupPaging
        
        if let suppViews = supplementaryViews {
            section.boundarySupplementaryItems = suppViews
        }
      //  section.decorationItems = [background]
        
        return section
    }
    
    
}


