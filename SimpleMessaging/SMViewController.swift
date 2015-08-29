//
//  SMViewController.swift
//  SimpleMessaging
//
//  Created by Seth on 8/29/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit
import PureLayout

class SMViewController: UIViewController {
    var backgroundView = BackgroundView.newAutoLayoutView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createLayout()
    }
    
    func createLayout(){
        self.view.addSubview(self.backgroundView)
        self.backgroundView.autoPinEdgesToSuperviewEdges()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
