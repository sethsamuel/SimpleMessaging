//
//  LoginViewController.swift
//  SimpleMessaging
//
//  Created by Seth on 8/29/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit

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
    
    var usernameTextField = SMTextField.newAutoLayoutView()
    var emailTextField = SMTextField.newAutoLayoutView()
    var passwordTextField = SMTextField.newAutoLayoutView()
    var submitButton = UIButton.newAutoLayoutView()
    var toggleFormButton = UIButton.newAutoLayoutView()
    
    var loginConstraints = []
    var joinConstraints = []
    
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
        
        var _loginConstraints = [NSLayoutConstraint]()
        var _joinConstraints = [NSLayoutConstraint]()
        
        usernameTextField.alpha = 0
        usernameTextField.backgroundColor = UIColor.whiteColor()
        usernameTextField.placeholder = "username"
        self.view.addSubview(usernameTextField)
        usernameTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: headerLabel, withOffset: 16)
        usernameTextField.autoAlignAxisToSuperviewAxis(.Vertical)
        usernameTextField.autoMatchDimension(.Width, toDimension: .Width, ofView: headerLabel)
        
        emailTextField.alpha = 0
        emailTextField.placeholder = "email"
        emailTextField.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(emailTextField)
        emailTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: usernameTextField, withOffset: 16)

        passwordTextField.alpha = 0
        passwordTextField.backgroundColor = UIColor.whiteColor()
        passwordTextField.placeholder = "password"
        passwordTextField.secureTextEntry = true
        self.view.addSubview(passwordTextField)
        _loginConstraints.append(passwordTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: usernameTextField, withOffset: 16))
        (_loginConstraints as NSArray).autoRemoveConstraints()
        _joinConstraints.append(passwordTextField.autoPinEdge(.Top, toEdge: .Bottom, ofView: emailTextField, withOffset: 16))

        
        toggleFormButton.alpha = 0
        toggleFormButton.rac_signalForControlEvents(.TouchUpInside).subscribeNext { _ in
            switch self.viewState{
            case .Login:
                self.viewState = .Join
            case .Join:
                self.viewState = .Login
            default:
                break
            }
        }
        self.view.addSubview(toggleFormButton)
        toggleFormButton.autoPinEdge(.Top, toEdge: .Bottom, ofView: passwordTextField, withOffset: 32)
        
        let views = [usernameTextField, emailTextField, passwordTextField, toggleFormButton]
        (views as NSArray).autoAlignViewsToAxis(.Vertical)
        (views as NSArray).autoMatchViewsDimension(.Width)
        
        self.loginConstraints = _loginConstraints
        self.joinConstraints = _joinConstraints
        self.loginConstraints.autoRemoveConstraints()
        self.joinConstraints.autoRemoveConstraints()

//        usernameTextField.rac_signalForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.joinConstraints.autoInstallConstraints()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animateWithDuration(
            0.1,
            delay: 0.1,
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
        UIView.animate(duration: 1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut|UIViewAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            switch self.viewState{
            case .Login:
                self.joinConstraints.autoRemoveConstraints()
                self.loginConstraints.autoInstallConstraints()
                
                self.usernameTextField.alpha = 1
                self.emailTextField.alpha = 0
                self.passwordTextField.alpha = 1
                self.toggleFormButton.alpha = 1

            case .Join:
                self.loginConstraints.autoRemoveConstraints()
                self.joinConstraints.autoInstallConstraints()
                
                self.usernameTextField.alpha = 1
                self.emailTextField.alpha = 1
                self.passwordTextField.alpha = 1
                self.toggleFormButton.alpha = 1
                
            default:
                break
            }
            
            self.view.layoutIfNeeded()
            }
            ).then { _ -> Void in
                switch self.viewState{
                case .Login:
                    self.toggleFormButton.setTitle("I need to join", forState: .Normal)
                case .Join:
                    self.toggleFormButton.setTitle("I have an account", forState: .Normal)
                default:
                    break
                }
        }
    }
}
