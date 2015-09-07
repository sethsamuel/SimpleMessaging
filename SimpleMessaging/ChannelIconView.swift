//
//  ChannelIconView.swift
//  SimpleMessaging
//
//  Created by Seth on 9/5/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit
import MMX
import UIColor_Hex_Swift

class ChannelIconView : UIView{
    var channel : MMXChannel = MMXChannel(){
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        let hash = channel.name.md5
        
        NSLog("Hash length %d", count(hash))
        
//        UIColor(rgba: hash[advance(hash.endIndex, -6)]).setFill()
        let hexColor = "#" + hash.substringFromIndex(advance(hash.endIndex, -6))
        UIColor(rgba: hexColor).setFill()
        UIColor(rgba: hexColor).setStroke()
        NSLog("hash %@", hash)
        var bytes = [UInt8]()
        for char in hash.utf8{
            bytes += [char]
        }
        
        
        for var i = 0.0; i < 5; i++ {
            for var j = 0.0; j < 5; j++ {
//                let char = hash[advance(hash.startIndex,Int(i*5+j))]
                let byte = bytes[Int(i*5+j)]
                NSLog("Byte %d", byte)
                if byte < 75 {
                    continue
                }
                
                let path = UIBezierPath()
                path.moveToPoint(CGPointMake(CGFloat(i) * CGRectGetWidth(rect)/5.0,CGFloat(j) * CGRectGetHeight(rect)/5.0))
                path.addLineToPoint(CGPointMake(CGFloat(i+1) * CGRectGetWidth(rect)/5.0,CGFloat(j) * CGRectGetHeight(rect)/5.0))
                path.addLineToPoint(CGPointMake(CGFloat(i+1) * CGRectGetWidth(rect)/5.0,CGFloat(j+1) * CGRectGetHeight(rect)/5.0))
                path.addLineToPoint(CGPointMake(CGFloat(i) * CGRectGetWidth(rect)/5.0,CGFloat(j+1) * CGRectGetHeight(rect)/5.0))
                path.closePath()
                path.fill()
                path.stroke()
            }
        }
    }
}
