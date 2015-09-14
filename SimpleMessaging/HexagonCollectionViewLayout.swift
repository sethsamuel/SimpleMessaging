//
//  HexagonCollectionViewLayout.swift
//  SimpleMessaging
//
//  Created by Seth on 9/14/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit

class HexagonCollectionViewLayout: UICollectionViewLayout {
    override func collectionViewContentSize() -> CGSize {
        return self.collectionView!.bounds.size;
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let i = indexPath.item%5
        let row = floor(Double(indexPath.item)/5.0)
        let yOffset = row*(60*1.5+8)
        if i < 3 {
            attributes.frame = CGRectMake(CGFloat(i*60+(i-1)*4), CGFloat(yOffset), 60, 60)
        } else {
            let xOffset = Double((i-3)*60+(i-4)*4)+60*0.5+2
            attributes.frame = CGRectMake(CGFloat(xOffset), CGFloat(yOffset+60*0.75+4), 60, 60)
        }
        
        return attributes
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        if elementKind == UICollectionElementKindSectionHeader{
            attributes.frame = CGRectMake(0, 0, self.collectionView!.bounds.size.width, 40)
        }
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        layoutAttributes.append(self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: 0)))

        //Elements
        for i in 0...(self.collectionView!.numberOfItemsInSection(0)-1) {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            layoutAttributes.append(self.layoutAttributesForItemAtIndexPath(indexPath))
        }

        return layoutAttributes
    }
    
}