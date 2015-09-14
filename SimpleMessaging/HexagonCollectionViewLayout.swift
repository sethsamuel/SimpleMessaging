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

        let width = (CGRectGetWidth(self.collectionView!.bounds)-Constants.GridGutterWidth*4.0)/3.0
        let height = CGFloat(2.0/sqrtf(3))*width
        
        let row = floor(Double(indexPath.item)/5.0)
        let xOffset = Constants.GridGutterWidth*2.0
        let yOffset = row*(Double(height)*1.5+Double(Constants.GridGutterWidth)*2.0)+40

        if i < 3 {
            attributes.frame = CGRectMake(CGFloat(xOffset) + CGFloat(i*Int(width)+(i-1)*Int(Constants.GridGutterWidth)), CGFloat(yOffset), width, height)
        } else {
            let xOffset2 = Double((i-3)*Int(width)+(i-4)*Int(Constants.GridGutterWidth))+Double(width)*0.5+Double(Constants.GridGutterWidth)/2.0
            attributes.frame = CGRectMake(CGFloat(xOffset) + CGFloat(xOffset2), CGFloat(yOffset+Double(height)*0.75+Double(Constants.GridGutterWidth)), width, height)
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