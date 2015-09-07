//
//  HexagonCollectionViewCell.swift
//  SimpleMessaging
//
//  Created by Seth on 9/5/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit

class HexagonCollectionViewCell : UICollectionViewCell{
    let shapeLayer = CAShapeLayer()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()

        //Add cell background shap
        shapeLayer.fillColor = UIColor(white: 1, alpha: 0.75).CGColor
        self.layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = self.layer.bounds
        let polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(97, 0))
        polygonPath.addLineToPoint(CGPointMake(194, 56))
        polygonPath.addLineToPoint(CGPointMake(194, 168))
        polygonPath.addLineToPoint(CGPointMake(97, 224))
        polygonPath.addLineToPoint(CGPointMake(0, 168))
        polygonPath.addLineToPoint(CGPointMake(0, 56))
        polygonPath.closePath()
        var scaleTransform = CGAffineTransformMakeScale(CGRectGetWidth(shapeLayer.frame)/194.0, CGRectGetHeight(shapeLayer.frame)/224.0)
//        shapeLayer.path = CGPathCreateCopyByTransformingPath(polygonPath, &scaleTransform)
        shapeLayer.path = withUnsafePointer(&scaleTransform){ (transform: UnsafePointer<CGAffineTransform>) -> (CGPath) in
            return CGPathCreateCopyByTransformingPath(polygonPath.CGPath, transform)
        }
    }

}
