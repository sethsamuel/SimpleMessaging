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
        collectionView.registerClass(ChannelCollectionViewCell.self, forCellWithReuseIdentifier: "channelCell")
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        if indexPath.row == 0{
            //Add channel
            let alert = UIAlertController(title: "New Channel", message: "What's the frequency, Kenneth?", preferredStyle: .Alert)
            alert.addTextFieldWithConfigurationHandler{ (textField : UITextField!) -> Void in
                textField.placeholder = "Channel name"
                textField.keyboardType = UIKeyboardType.ASCIICapable
            }
            alert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default) { (action) -> Void in
                if let nameField = alert.textFields?.first as? UITextField{
                    let channel = MMXChannel(name: nameField.text, summary: "")
                    channel.isPublic = true
                    channel.create()
                        .then{ 
                            return channel.setTags(["SimpleMessaging"])
                    }
                        .then{
                            self.refreshData()
                        }
                    .catch(policy: .AllErrors, { (error) -> Void in
                        NSLog("Error creating %@", error)
                    })
                    
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
                alert.dismissViewControllerAnimated(true) { () -> Void in
                    
                }
            })
            self.presentViewController(alert, animated: true) { () -> Void in
                
            }
            
        }else{
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? HexagonCollectionViewCell{
                let shape = cell.shapeLayer
                let originalPath = CGPathCreateCopy(shape.path)

                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = 1.0
                animation.fromValue = shape.path
                let rectPath = UIBezierPath()
                rectPath.moveToPoint(CGPointMake(CGRectGetWidth(cell.bounds)/2.0, 0))
                rectPath.addLineToPoint(CGPointMake(CGRectGetWidth(cell.bounds), 0))
//                rectPath.addLineToPoint(CGPointMake(CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds)/4.0))
//                rectPath.addLineToPoint(CGPointMake(CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds)/4.0*3.0))
                rectPath.addLineToPoint(CGPointMake(CGRectGetWidth(cell.bounds), CGRectGetHeight(cell.bounds)))
                rectPath.addLineToPoint(CGPointMake(CGRectGetWidth(cell.bounds)/2.0, CGRectGetHeight(cell.bounds)))
                rectPath.addLineToPoint(CGPointMake(0, CGRectGetHeight(cell.bounds)))
//                rectPath.addLineToPoint(CGPointMake(0, CGRectGetHeight(cell.bounds)/4.0*3.0))
//                rectPath.addLineToPoint(CGPointMake(0, CGRectGetHeight(cell.bounds)/4.0))
                rectPath.addLineToPoint(CGPointMake(0, 0))
                rectPath.closePath()
                shape.path = rectPath.CGPath
                animation.toValue = shape.path
                shape.promiseAnimation(animation, forKey: animation.keyPath)
                    .then{ _ -> Void in
                }
            }
        }
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
        let width = (CGRectGetWidth(collectionView.bounds)-Constants.GridGutterWidth*4.0)/3.0
        let height = CGFloat(2.0/sqrtf(3))*width
        return CGSizeMake(width, height)
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
        return channels.count+1
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
        let cell : ChannelCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("channelCell", forIndexPath: indexPath) as! ChannelCollectionViewCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            (cell as! ChannelCollectionViewCell).isAddCell = true
        }else{
            let channel = channels[indexPath.row-1]
            (cell as! ChannelCollectionViewCell).isAddCell = false
            (cell as! ChannelCollectionViewCell).channel = channel
        }
    }
}

