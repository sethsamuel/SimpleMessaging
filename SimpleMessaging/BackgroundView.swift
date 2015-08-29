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
        self.drawCanvas2(primary: self.color)
    }
    
    func drawCanvas2(#primary: UIColor) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        var primaryHueComponent: CGFloat = 1,
        primarySaturationComponent: CGFloat = 1,
        primaryBrightnessComponent: CGFloat = 1
        primary.getHue(&primaryHueComponent, saturation: &primarySaturationComponent, brightness: &primaryBrightnessComponent, alpha: nil)
        
        let darkPrimary = UIColor(hue: primaryHueComponent, saturation: primarySaturationComponent, brightness: 0.4, alpha: CGColorGetAlpha(primary.CGColor))
        
        //// Gradient Declarations
        let background = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [primary.CGColor, darkPrimary.CGColor], [0, 1])
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRectMake(0, 0, 414, 736))
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawRadialGradient(context, background,
            CGPointMake(261.38, 212.07), 132.82,
            CGPointMake(147.29, 427.71), 560.14,
            UInt32(kCGGradientDrawsBeforeStartLocation) | UInt32(kCGGradientDrawsAfterEndLocation))
        CGContextRestoreGState(context)
    }
}
