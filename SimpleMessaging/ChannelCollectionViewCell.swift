//
//  ChannelCollectionViewCell.swift
//  SimpleMessaging
//
//  Created by Seth on 9/5/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit
import MMX
import FontAwesomeIconFactory


class ChannelCollectionViewCell : HexagonCollectionViewCell{
    private let label : UILabel = UILabel.newAutoLayoutView()
    private let icon : ChannelIconView = ChannelIconView()
    private let addIcon = UIImageView.newAutoLayoutView()
    var isAddCell  = false {
        didSet{
            self.addIcon.hidden = !isAddCell
        }
    }
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
        
//        addButton.setTitle("+", forState: .Normal)
        let factory = NIKFontAwesomeIconFactory.buttonIconFactory()
        factory.colors = [UIColor.simpleMessagingPrimary()]
        factory.size = 196
        addIcon.image = factory.createImageForIcon(.IconPlus)
        addIcon.contentMode = .ScaleAspectFill
//        addButton.setTitleColor(UIColor.simpleMessagingPrimary(), forState: .Normal)
        self.addSubview(addIcon)
        addIcon.autoCenterInSuperview()
        addIcon.autoMatchDimension(.Height, toDimension: .Height, ofView: self, withMultiplier: 0.5)
        addIcon.autoMatchDimension(.Width, toDimension: .Height, ofView: addIcon)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
//        label.text = ""
        icon.alpha = 0
        addIcon.hidden = true
    }
}
