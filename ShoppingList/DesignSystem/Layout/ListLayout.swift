//
//  ListLayout.swift
//  ShoppingList
//
//  Created by Dasha Palshau on 12.12.2021.
//

import UIKit

protocol ListLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView,
                        width: CGFloat,
                        heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}

class ListLayout<Cell: ListCell>: UICollectionViewFlowLayout {
    
    let minHeight: CGFloat = 52
    let interitemSpacing: CGFloat = 4
    
    weak var delegate: ListLayoutDelegate?
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // Returns the size of the collection view’s contents.
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // prepare() is called whenever the collection view's layout becomes invalid.
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        var yOffset: CGFloat = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            var itemHeight = minHeight
            
            if let estimatedHeight = delegate?.collectionView(
                collectionView,
                width: contentWidth,
                heightForItemAtIndexPath: indexPath
            ) {
                itemHeight = max(estimatedHeight, minHeight)
            }
            
            let height = interitemSpacing * 2 + itemHeight
            let frame = CGRect(x: 0,
                               y: yOffset,
                               width: contentWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: 16, dy: interitemSpacing)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            
            yOffset = yOffset + height
        }
    }
    
    // The collection view calls it after prepare() to determine which items are visible in the given rectangle.
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    // Retrieve and return from cache the layout attributes which correspond to the requested indexPath.
    override func layoutAttributesForItem(at indexPath: IndexPath)
    -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
