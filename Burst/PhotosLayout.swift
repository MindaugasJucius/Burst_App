//
//  PhotosLayout.swift
//  Burst
//
//  Created by Mindaugas Jucius on 24/06/16.
//  Copyright © 2016 mindaugo.kompanija.limited. All rights reserved.
//

import UIKit

protocol PhotosLayoutDelegate {
    // 1
    func heightForPhotoAtIndexPath(photoIndexPath indexPath:NSIndexPath) -> CGFloat
    
    func itemCount() -> Int

}

let PhotoDetailsSupplementaryViewKind = "PhotoDetailsSupplementaryView"

class PhotosLayout: UICollectionViewLayout {
    var delegate: PhotosLayoutDelegate!
    
    // 2
    var numberOfColumns = 2
    var cellPadding: CGFloat = 1.0
    var itemCount = 0
    
    // 3
    private var cache = [UICollectionViewLayoutAttributes]()
    //private var supplementaryCache = [UICollectionViewLayoutAttributes]()
    private var cellCache = [UICollectionViewLayoutAttributes]()
    
    // 4
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache
    }
    
    override func initialLayoutAttributesForAppearingSupplementaryElementOfKind(elementKind: String, atIndexPath elementIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.initialLayoutAttributesForAppearingSupplementaryElementOfKind(PhotoDetailsSupplementaryViewKind, atIndexPath: elementIndexPath)
        attrs?.transform = CGAffineTransformMakeRotation(90)
        return attrs
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        guard let attributes = attrs else { return .None }
        attributes.alpha = 0
        return attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return cellCache[indexPath.row]
    }
    
    override func prepareLayout() {
        
        guard itemCount != delegate.itemCount() else { return }
        
        cellCache = []
        cache = []
        //supplementaryCache = []
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth )
        }
        var column = 0
        var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
        
        // 3
        for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
            
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            
            // 4
            let photoHeight = delegate.heightForPhotoAtIndexPath(photoIndexPath: indexPath)
            
            let height = cellPadding +  photoHeight + cellPadding// + 40
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
            
            // 5
            
            let cellAttrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            cellAttrs.frame = insetFrame
            //cellAttrs.alpha = 1
            cellCache.append(cellAttrs)
            
//            let supplementaryViewAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: PhotoDetailsSupplementaryViewKind, withIndexPath: indexPath)
//            var supplementaryViewFrame = cellAttrs.frame
//            supplementaryViewFrame.origin.y += cellAttrs.frame.height - 40
//            supplementaryViewFrame.size.height = 40
//            supplementaryViewAttributes.frame = supplementaryViewFrame
//            supplementaryViewAttributes.zIndex = 1000
//            supplementaryCache.append(supplementaryViewAttributes)
            
            // 6
            contentHeight = max(contentHeight, CGRectGetMaxY(frame))
            yOffset[column] = yOffset[column] + height
            cache.appendContentsOf(cellCache)
            //cache.appendContentsOf(supplementaryCache)
            column = column >= (numberOfColumns - 1) ? 0 : column + 1
        }
        
        itemCount = delegate.itemCount()
        
    }
    
//    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        return supplementaryCache[indexPath.row]
//    }
    
}
