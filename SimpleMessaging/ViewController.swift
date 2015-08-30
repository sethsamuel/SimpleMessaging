//
//  ViewController.swift
//  SimpleMessaging
//
//  Created by Seth on 8/28/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit
import PromiseKit
import MMX_PromiseKit

class ViewController: SMViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


//        NSURLConnection.GET("google.com").then{
//            (image : UIImage) in
//            self.view.addSubview(UIImageView(image: image));
//        };
//        MMXChannel.subscribedChannels()
//            .then{ (channels : [MMXChannel]) in
//                
//        };
//        MMXChannel().tags().then { (tags : [String]) in
//            
//        };
    }
    override func createLayout() {
        super.createLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let p = MMXChannel.subscribedChannels() as AnyPromise;
        p.then{ (t : AnyObject?) -> AnyPromise in
            let tags = t as! [String];
            
            for tag in tags{
                NSLog("%@", tag);
            }
            
            return AnyPromise(bound: Promise());
        };
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

