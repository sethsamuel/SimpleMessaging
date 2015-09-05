//
//  ChannelsViewController.swift
//  SimpleMessaging
//
//  Created by Seth on 8/28/15.
//  Copyright (c) 2015 Seth Samuel. All rights reserved.
//

import UIKit
import PureLayout
import PromiseKit
import MMX
import MMX_PromiseKit
import FontAwesomeIconFactory

class ChannelsViewController: SMViewController {

    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    let refreshControl = UIRefreshControl()
    var channels : [MMXChannel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func createLayout() {
        super.createLayout()
        

        self.automaticallyAdjustsScrollViewInsets = true
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame), 0, 0, 0)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "channelCell")
        collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "channelsHeader")
        self.view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
        
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.rac_signalForControlEvents(.ValueChanged).subscribeNext{ _ in
            self.refreshData()
        }
        collectionView.addSubview(refreshControl)
//        refreshControl.autoAlignAxisToSuperviewAxis(.Vertical)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func refreshData(){
        MMXChannel.findByTags(["SimpleMessaging"])
            .then{
                count, channels -> Void in
                self.channels = channels
                self.refreshControl.endRefreshing()
        }.catch(policy: .AllErrors) { (error) -> Void in
            if error.domain == MMXErrorDomain && error.code == 403{
                //Try to relogin
                let credentials = NSURLCredentialStorage.sharedCredentialStorage().credentialsForProtectionSpace(Constants.MMXProtectionSpace)
                if let credential = credentials?.values.first as? NSURLCredential{
                    MMXUser.logInWithCredential(credential)
                        .then { _ -> Void in
                            self.refreshData()
                        }.catch(policy: .AllErrors) { (error) -> Void in
                            //TODO: Add error
                            self.refreshControl.endRefreshing()
                    }
                }else{
                    //TODO: Add error
                    self.refreshControl.endRefreshing()
                }
            }else{
                //TODO: Add error message
                self.refreshControl.endRefreshing()
            }
        }
//        let p = MMXChannel.findByTags(["SimpleMessaging"]) as AnyPromise;
//        p.then{ (o : AnyObject?) -> Void in
//            if let channels = c as?  {
//                self.channels = channels
//            }
//            self.refreshControl.endRefreshing()
//        }
    }

}

extension ChannelsViewController : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
}

extension ChannelsViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return Constants.GridGutterWidth
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return Constants.GridGutterWidth
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return Constants.LayoutMargins
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (CGRectGetWidth(collectionView.bounds)-Constants.GridGutterWidth*3.0)/2.0
        return CGSizeMake(width, width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 40)
    }
    
}

extension ChannelsViewController : UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionElementKindSectionHeader:
            let header : UICollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "channelsHeader", forIndexPath: indexPath) as! UICollectionReusableView
            let button = UIButton()
            button.setTitle("Logout", forState: .Normal)
            button.titleLabel?.font = button.titleLabel?.font.fontWithSize(14)
            let factory = NIKFontAwesomeIconFactory.buttonIconFactory()
            factory.colors = [UIColor.whiteColor()]
            button.setImage(factory.createImageForIcon(.IconSignOut), forState: .Normal)
            
            button.rac_signalForControlEvents(.TouchUpInside).subscribeNext { _ in
                MMXUser.logOut()
                    .then{ _ -> Void in
                        if let credentials = NSURLCredentialStorage.sharedCredentialStorage().credentialsForProtectionSpace(Constants.MMXProtectionSpace) as? [NSString:NSURLCredential] {
                            for credential in credentials.values{
                                NSURLCredentialStorage.sharedCredentialStorage().removeCredential(credential, forProtectionSpace: Constants.MMXProtectionSpace)
                            }
                        }
                        NSNotificationCenter.defaultCenter().postNotificationName("USER_DID_CHANGE", object: nil)
                }
            }
            header.addSubview(button)
            button.autoAlignAxisToSuperviewAxis(.Horizontal)
            button.autoPinEdgeToSuperviewEdge(.Trailing, withInset: Constants.GridGutterWidth)
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("channelCell", forIndexPath: indexPath) as! UICollectionViewCell
        cell.backgroundColor = UIColor.whiteColor()
        let channel = channels[indexPath.row]
        let label = UILabel()
        label.text = channel.name
        cell.addSubview(label)
        label.autoCenterInSuperview()
        label.textAlignment = .Center
        label.autoMatchDimension(.Width, toDimension: .Width, ofView: cell, withOffset: -2.0*Constants.GridGutterWidth)
        
        return cell
    }
}

