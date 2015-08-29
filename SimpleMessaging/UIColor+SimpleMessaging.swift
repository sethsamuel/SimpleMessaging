//
//  UIColor+SimpleMessaging.swift
//  SimpleMessaging
//
//  Created by Seth on 8/29/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit

extension UIColor{
    class func simpleMessagingPrimary() -> UIColor {
        return UIColor(red: 0.383, green: 0, blue: 0.672, alpha: 1)
    }

    class func simpleMessagingPrimaryLight() -> UIColor {
        var primaryRedComponent: CGFloat = 1,
        primaryGreenComponent: CGFloat = 1,
        primaryBlueComponent: CGFloat = 1,
        primaryAlphaComponent: CGFloat = 1
        UIColor.simpleMessagingPrimary().getRed(&primaryRedComponent, green: &primaryGreenComponent, blue: &primaryBlueComponent, alpha: &primaryAlphaComponent)
        
        return UIColor(red: (primaryRedComponent * 0.1 + 0.9), green: (primaryGreenComponent * 0.1 + 0.9), blue: (primaryBlueComponent * 0.1 + 0.9), alpha: (primaryAlphaComponent * 0.1 + 0.9))

    }
}
