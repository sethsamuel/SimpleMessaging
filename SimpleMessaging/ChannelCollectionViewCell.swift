//
//  ChannelCollectionViewCell.swift
//  SimpleMessaging
//
//  Created by Seth on 9/5/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit
import MMX

class ChannelCollectionViewCell : HexagonCollectionViewCell{
    private let label : UILabel = UILabel.newAutoLayoutView()
    private let icon : ChannelIconView = ChannelIconView()
    var channel:MMXChannel = MMXChannel() {
        didSet{
//            label.text = channel.name
            icon.channel = channel
            UIView.animate(duration: 0.5, delay: 0, options: .CurveEaseInOut) { () -> Void in
                self.icon.alpha = 1
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.addSubview(label)
//        label.autoCenterInSuperview()
//        label.textAlignment = .Center
//        label.autoMatchDimension(.Height, toDimension: .Height, ofView: self, withMultiplier: 0.5)
//        label.autoMatchDimension(.Width, toDimension: .Height, ofView: label)
//        label.backgroundColor = UIColor.redColor()
        
        self.addSubview(icon)
        icon.autoCenterInSuperview()
        icon.autoMatchDimension(.Height, toDimension: .Height, ofView: self, withMultiplier: 0.5)
        icon.autoMatchDimension(.Width, toDimension: .Height, ofView: icon)
        
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
//        label.text = ""
        icon.alpha = 0
    }
}
