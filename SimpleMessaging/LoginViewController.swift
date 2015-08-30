//
//  LoginViewController.swift
//  SimpleMessaging
//
//  Created by Seth on 8/29/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit
import PureLayout
import ReactiveCocoa

enum ViewState{
    case Preload
    case Login
    case Join
}

class LoginViewController: SMViewController {
    var  viewState:ViewState = .Preload {
        didSet{
            self.render()
        }
    }
    var headerLabel = UILabel.newAutoLayoutView()
    
    var usernameTextField = UITextField.newAutoLayoutView()
    var emailTextField = UITextField.newAutoLayoutView()
    var passwordTextField = UITextField.newAutoLayoutView()
    var submitButton = UIButton.newAutoLayoutView()
    var toggleFormButton = UIButton.newAutoLayoutView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func createLayout(){
        super.createLayout()
        
        self.backgroundView.color = UIColor.simpleMessagingPrimaryLight()
        
        headerLabel.text = "Simple Messaging"
        headerLabel.textAlignment = .Center;
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.minimumScaleFactor = 0.5
        headerLabel.layer.shadowColor = UIColor.blackColor().CGColor
        headerLabel.layer.shadowOpacity = 0.1
        headerLabel.layer.shadowRadius = 3;
        headerLabel.layer.shadowOffset = CGSizeZero
        headerLabel.alpha = 0
        self.view.addSubview(headerLabel)
        headerLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        headerLabel.autoPinToTopLayoutGuideOfViewController(self, withInset: 32)
        headerLabel.autoMatchDimension(.Width, toDimension: .Width, ofView: self.view, withOffset: -64)
        
        
//        usernameTextField.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animateWithDuration(
            1.0,
            delay: 0.5,
            options: .CurveEaseInOut,
            animations: {
                self.headerLabel.alpha = 1
            },
            completion: { (finished: Bool)  in
                self.viewState = .Join;
            }
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Have to put this hear to override UIAppearance
        headerLabel.font = Constants.HugeHeaderFont
    }
    
    func render(){
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut|UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            switch self.viewState{
            case .Login:
                self.headerLabel.transform = CGAffineTransformIdentity
            case .Join:
                self.headerLabel.transform = CGAffineTransformIdentity
            default:
                //Noop
                self.headerLabel.transform = CGAffineTransformIdentity
            }
            }, completion : { (completed) -> Void in
                
        })
    }
}
