//
//  BackgroundView.swift
//  SimpleMessaging
//
//  Created by Seth on 8/29/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit
import PureLayout

class BackgroundView: UIView {
    var color: UIColor = UIColor.simpleMessagingPrimary() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        self.drawCanvas2(primary: self.color, rect: rect)
    }
    
    func drawCanvas2(#primary: UIColor, rect : CGRect) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        var primaryRedComponent: CGFloat = 1,
        primaryGreenComponent: CGFloat = 1,
        primaryBlueComponent: CGFloat = 1
        primary.getRed(&primaryRedComponent, green: &primaryGreenComponent, blue: &primaryBlueComponent, alpha: nil)
        
        let darkPrimary = UIColor(red: (primaryRedComponent * 0.6), green: (primaryGreenComponent * 0.6), blue: (primaryBlueComponent * 0.6), alpha: (CGColorGetAlpha(primary.CGColor) * 0.6 + 0.4))
        
        
        //// Gradient Declarations
        let background = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [primary.CGColor, darkPrimary.CGColor], [0, 1])
        
        //// Rectangle Drawing
        let widthScale = rect.width/414.0
        let heightScale = rect.height/736.0
        let rectanglePath = UIBezierPath(rect: CGRectMake(0, 0, 414*widthScale, 736*heightScale))
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawRadialGradient(context, background,
            CGPointMake(261.38*widthScale, 212.07*heightScale), 132.82*heightScale,
            CGPointMake(147.29*widthScale, 427.71*heightScale), 560.14*heightScale,
            UInt32(kCGGradientDrawsBeforeStartLocation) | UInt32(kCGGradientDrawsAfterEndLocation))
        CGContextRestoreGState(context)
    }
}
