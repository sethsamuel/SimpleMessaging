//
//  AppDelegate.swift
//  SimpleMessaging
//
//  Created by Seth on 8/28/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit
import MMX
import ReactiveCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let frame = UIScreen.mainScreen().bounds;
        self.window = UIWindow(frame: frame)

        if let user = MMXUser.currentUser(){
            self.window?.rootViewController = ViewController()
            self.window?.makeKeyAndVisible()
        }else{
            self.window?.rootViewController = LoginViewController()
            self.window?.makeKeyAndVisible()
        }

        
        UILabel.appearance().font = Constants.BodyFont
        
        //Initialize MMX
        MMX.setupWithConfiguration("default")
        
        NSNotificationCenter.defaultCenter()
            .rac_addObserverForName("USER_DID_CHANGE", object: nil)
            .takeUntil(self.rac_willDeallocSignal())
            .subscribeNext { (notification) -> Void in
                self.userDidChange()
        }
        
        return true
    }
    

    private func userDidChange(){
        if let user = MMXUser.currentUser(){
            self.window?.rootViewController = ViewController()
        }else{
            self.window?.rootViewController = LoginViewController()
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

