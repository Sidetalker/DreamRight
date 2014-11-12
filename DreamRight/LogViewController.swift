//
//  LogViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/8/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

struct LogEntry {
    var date: NSDate
    var name: String
    var tags: [String]
    var dreams: [LogDream]
    var isHidden: Int
}

struct LogDream {
    var recording: NSData?
    var name: String
    var description: String
    var time: NSDate
    var tags: [String]
}

class LogViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var entries: [LogEntry]?
    var parent: LogContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the custom cell xib file
        self.collectionView.registerNib(UINib(nibName: "LogCell", bundle: nil), forCellWithReuseIdentifier: "logCell")
        
        // Load dummy data
        entries = [LogEntry]()
        
        for x in 0...10 {
            let nightTime = NSDate(timeIntervalSinceReferenceDate: NSTimeInterval(250000 * x))
            let nightName = "Original Name #\(x)"
            var nightTags = [String]()
            
            if Int(randomFloatBetweenNumbers(1, 2)) % 2 == 0 {
                nightTags.append("tag4")
            }
            else {
                nightTags.append("tag5")
            }
            
            var dreams = [LogDream]()
            
            for y in 0...Int(randomFloatBetweenNumbers(0, 3)) {
                let dreamTime = NSDate(timeInterval: NSTimeInterval(1000 * y), sinceDate: nightTime)
                let dreamName = "Original Name #\(x * y)"
                let dreamDescription = "Original Description #\(x * y)"
                var dreamTags = ["tag2"]
                
                if Int(randomFloatBetweenNumbers(1, 2)) % 2 == 0 {
                    dreamTags.append("tag2")
                }
                else {
                    dreamTags.append("tag5")
                }
                
                dreams.append(LogDream(recording: nil, name: dreamName, description: dreamDescription, time: dreamTime, tags: dreamTags))
            }
            
            entries!.append(LogEntry(date: nightTime, name: nightName, tags: nightTags, dreams: dreams, isHidden: 0))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func viewDidAppear(animated: Bool) {
        self.collectionView.setCollectionViewLayout(SpringyFlow(), animated: true)
        
        for x in 0...entries!.count - 1 {
            let delayTime = Double(x) * 0.1
            
            delay(delayTime, {
                self.entries![x].isHidden = 1
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: - UICollectionView Delegates
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = entries?.count {
            return count
        }
        
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let myCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("logCell", forIndexPath: indexPath) as LogCell
        
        var curEntry = entries![indexPath.row]
        
        let format = NSDateFormatter()
        format.dateFormat = "EEEE, MMMM d, yyyy"
        
        let dateString = format.stringFromDate(curEntry.date)
        
        myCell.lblDate.text = dateString
        myCell.lblDreamCount.text = "\(curEntry.dreams.count)"
        myCell.lblNightName.text = curEntry.name
        
        if !myCell.configured {
            myCell.configure()
        }
        
        return myCell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cellAttributes = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        var cellFrame = self.collectionView.convertRect(cellAttributes!.frame, toView: self.view)
        
        let nightEntry = entries![indexPath.row]
        
        var dreamBoxes = [DreamBox]()
        
        self.view.backgroundColor = DreamRightSK.color
        
        for x in 0...nightEntry.dreams.count {
            let newView = DreamBox(frame: cellFrame)
            newView.alpha = 1
            newView.configure()
            
            dreamBoxes.append(newView)
            self.parent!.view.addSubview(newView)
        }
        
        self.view.sendSubviewToBack(self.collectionView)
        self.parent!.dreamCollection = self.collectionView
        
        UIView.animateWithDuration(0.6, animations: {
            self.collectionView.alpha = 0
        })
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            var navContainer = self.parent!.navContainer!
            var subNav = self.parent!.subNav!
            
            subNav.frame = CGRect(x: 0, y: navContainer.frame.height, width: navContainer.frame.width, height: 0)
            }, completion: {
                (value: Bool) in
                self.parent!.singleLabel?.hidden = true
                
                self.parent!.leftLabel?.hidden = false
                self.parent!.rightLabel?.hidden = false
                self.parent!.divider?.hidden = false
                
                self.parent!.navState = 1
        })
        
        UIView.animateWithDuration(0.7, delay: 0.3, usingSpringWithDamping: 0.52, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            var navContainer = self.parent!.navContainer!
            var subNav = self.parent!.subNav!
            
            subNav.frame = CGRect(x: 0, y: 0, width: navContainer.frame.width, height: navContainer.frame.height)
            }, completion: nil)
        
        for x in 0...dreamBoxes.count - 1 {
            var contextFrame = dreamBoxes[x].frame
            
            let miniFrame = CGRect(x: contextFrame.origin.x + 10, y: contextFrame.origin.y + 10, width: contextFrame.width - 20, height: contextFrame.height - 20)
            var finalFrame = CGRect()
            
            if x == 0 {
                finalFrame = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 66)
            }
            else {
                let boxCount: CGFloat = CGFloat(dreamBoxes.count - 1)
                let boxWidth = self.view.frame.width - 20
                let boxHeight = (self.view.frame.height - 86) / boxCount - 10
                let boxY = 76 + CGFloat(x - 1) * boxHeight + CGFloat(10 * x)
                let boxX: CGFloat = 10
                
                finalFrame = CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight)
            }
            
            let delayTime = Double(x) * 0.08
            
//            UIView.animateWithDuration(0.25, delay: 0.4, options: UIViewAnimationOptions.CurveEaseIn, animations: {
//                dreamBoxes[x].frame = miniFrame
//                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.15 + delayTime, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                dreamBoxes[x].frame = finalFrame
                }, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 20, height: 66)
    }
}

// MARK: - Physics enabled UICollectionViewFlowLayout

class SpringyFlow: UICollectionViewFlowLayout {
    var dynamicAnimator: UIDynamicAnimator?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        if dynamicAnimator == nil {
            dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        }
        
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.itemSize = CGSizeMake(200, 50);
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        let contentSize = self.collectionView!.contentSize
        let items = super.layoutAttributesForElementsInRect(CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)) as? [UIDynamicItem]
        
        if dynamicAnimator!.behaviors.count == 0 {
            for item in items! {
                let behaviour = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
                
                behaviour.length = 0
                behaviour.damping = 0.8
                behaviour.frequency = 1
                
                dynamicAnimator?.addBehavior(behaviour)
            }
        }
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if attributes == nil {
            return nil
        }
        
        var center = attributes!.center
        
        center.x -= self.collectionViewContentSize().width
        attributes!.center = center
        attributes!.alpha = 0
        
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return dynamicAnimator?.itemsInRect(rect)
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let scrollView = self.collectionView
        let delta = newBounds.origin.y - scrollView!.bounds.origin.y
        let touchLocation = self.collectionView!.panGestureRecognizer.locationInView(self.collectionView)
        let behaviours = dynamicAnimator!.behaviors as [UIAttachmentBehavior]
        
        for behaviour in behaviours {
            let yDistanceFromTouch = touchLocation.y - behaviour.anchorPoint.y
            let scrollResistance: CGFloat = (yDistanceFromTouch) / 1380
            
            let item = behaviour.items.first as UICollectionViewLayoutAttributes
            var center = item.center
            
            if delta < 0 {
                if item.center.y > touchLocation.y {
                    center.y -= max(delta, delta * scrollResistance)
                }
                else {
                    center.y += max(delta, delta * scrollResistance)
                }
            }
            else {
                if item.center.y > touchLocation.y {
                    center.y -= min(delta, delta * scrollResistance)
                }
                else {
                    center.y += min(delta, delta * scrollResistance)
                }
            }
            
            item.center = center
            
            dynamicAnimator?.updateItemUsingCurrentState(item)
        }
        
        return true
    }
}

// MARK: - Sexy custom UICollectionViewCell to use with our table

class LogCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var lblDreamCount: UILabel!
    @IBOutlet var lblNightName: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    // MARK: - States
    
    var configured = false
    
    // IBOutlet is not yet connected in this init
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // IBOutlet has become connected
    override init() {
        super.init()
    }
    
    func configure() {
        self.layer.borderColor = DreamRightSK.color2.CGColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 8
        
        configured = true
    }
}

// MARK: - Custom UIView for zooming in to dream detail

class DreamBox: UIView {
    
    @IBOutlet weak var owner: NSObject!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NSBundle.mainBundle().loadNibNamed("DreamView", owner: self, options: nil)
    }
    
    func configure() {
        self.backgroundColor = DreamRightSK.color
        
        self.layer.borderColor = DreamRightSK.color2.CGColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 8
    }
    
    func editJiggle(start: Bool) {
        if !start {
            self.layer.removeAllAnimations()
            return
        }
        
        let curFrame = self.frame
        let curOrigin = self.frame.origin
        
        let animation = CAKeyframeAnimation(keyPath: "transform")
        let wobbleAngle = CGFloat(0.011)
        
        let left = NSValue(CATransform3D: CATransform3DMakeRotation(wobbleAngle, 0, 0, 1))
        let right = NSValue(CATransform3D: CATransform3DMakeRotation(-wobbleAngle, 0, 0, 1))
        
        animation.values = [left, right]
        animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        animation.autoreverses = true
        animation.duration = 0.13
        animation.repeatCount = HUGE
        
        self.layer.addAnimation(animation, forKey: "transform")
    }
}

// MARK: - Custom Navigation Bar

class LogNav: UIViewController {
    
}

// MARK: - Log Container View

class LogContainer: UIViewController {
    @IBOutlet var dreamContainer: UIView!
    @IBOutlet var navContainer: UIView!
    
    var dreamCollection: UICollectionView!
    
    var subNav: UIView?
    var singleLabel: UILabel?
    var leftLabel: UILabel?
    var rightLabel: UILabel?
    var divider: UIView?
    
    var navTap: UITapGestureRecognizer?
    var navState = 0
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

        
        prepareNav()
        presentNav()
    }
    
    func presentNav() {
        let navFrame = navContainer.frame
        let newFrame = CGRect(x: 0, y: 0, width: navFrame.width, height: navFrame.height)
        
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.52, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.subNav!.frame = newFrame
            }, completion: nil)
    }
    
    func prepareNav() {
        let navFrame = navContainer.frame
        
        subNav = UIView(frame: CGRect(x: 0, y: navFrame.height, width: navFrame.width, height: 0))
        subNav?.backgroundColor = DreamRightSK.color2
        
        singleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: navFrame.width, height: navFrame.height))
        
        var textStyle = [NSObject : AnyObject]()
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        
        textStyle[NSForegroundColorAttributeName] = DreamRightSK.color
        textStyle[NSFontAttributeName] = UIFont(name: "Optima-Regular", size: 20)!
        textStyle[NSParagraphStyleAttributeName] = paragraphStyle
        
        let singleText = NSAttributedString(string: "Leave Your Dreams", attributes: textStyle)
        singleLabel!.attributedText = singleText
        
        leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: navFrame.width / 2, height: navFrame.height))
        rightLabel = UILabel(frame: CGRect(x: navFrame.width / 2, y: 0, width: navFrame.width / 2, height: navFrame.height))
        
        leftLabel?.hidden = true
        rightLabel?.hidden = true
        leftLabel?.userInteractionEnabled = false
        rightLabel?.userInteractionEnabled = false
        
        leftLabel?.attributedText = NSAttributedString(string: "Back", attributes: textStyle)
        rightLabel?.attributedText = NSAttributedString(string: "Edit", attributes: textStyle)
        
        divider = UIView(frame: CGRect(x: navFrame.width / 2, y: 0, width: 1, height: navFrame.height * 2))
        divider?.backgroundColor = DreamRightSK.color
        divider?.hidden = true
        divider?.userInteractionEnabled = false
        
        subNav!.addSubview(leftLabel!)
        subNav!.addSubview(rightLabel!)
        subNav!.addSubview(divider!)
        
        subNav!.addSubview(singleLabel!)
        subNav!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("navTap:")))
        
        navContainer.addSubview(subNav!)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logDreamSegue" {
            let dreamSegue = segue.destinationViewController as LogViewController
            
            dreamSegue.parent = self
        }
//        else if segue.identifier == "logSegue" {
//            let logVC = segue.destinationViewController as LogContainer
//            
//            logVC.transitioningDelegate = transitionManager
//        }
    }
    
    func navTap(gesture: UITapGestureRecognizer) {
        if navState == 0 {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else if navState == 1 || navState == 2 {
            let leftRec = CGRect(x: 0, y: 0, width: subNav!.frame.width / 2, height: subNav!.frame.height)
            let rightRec = CGRect(x: subNav!.frame.width / 2, y: 0, width: subNav!.frame.width / 2, height: self.subNav!.frame.height)
            
            if CGRectContainsPoint(leftRec, gesture.locationOfTouch(0, inView: subNav!)) {
                navState = 0
                
                for view in self.view.subviews {
                    if let box = view as? DreamBox {
                        box.removeFromSuperview()
                    }
                }
                
                UIView.animateWithDuration(0.9, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.dreamCollection.alpha = 1
                }, completion: nil)
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.subNav!.frame = CGRect(x: 0, y: self.navContainer.frame.height, width: self.navContainer.frame.width, height: 0)
                    }, completion: {
                        (value: Bool) in
                        self.singleLabel?.hidden = false
                        
                        self.leftLabel?.hidden = true
                        self.rightLabel?.hidden = true
                        self.divider?.hidden = true
                        
                        var textStyle = [NSObject : AnyObject]()
                        var paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = NSTextAlignment.Center
                        
                        textStyle[NSForegroundColorAttributeName] = DreamRightSK.color
                        textStyle[NSFontAttributeName] = UIFont(name: "Optima-Regular", size: 20)!
                        textStyle[NSParagraphStyleAttributeName] = paragraphStyle
                        
                        let doneText = NSAttributedString(string: "Edit", attributes: textStyle)
                        self.rightLabel!.attributedText = doneText
                })
                
                UIView.animateWithDuration(0.7, delay: 0.3, usingSpringWithDamping: 0.52, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.subNav!.frame = CGRect(x: 0, y: 0, width: self.navContainer.frame.width, height: self.navContainer.frame.height)
                    }, completion: nil)
            }
            else if CGRectContainsPoint(rightRec, gesture.locationOfTouch(0, inView: subNav!)) {
                if navState == 1 {
                    for view in self.view.subviews {
                        if let box = view as? DreamBox {
                            navState = 2
                            
                            box.editJiggle(true)
                            
                            UIView.animateWithDuration(0.2, animations: {
                                self.rightLabel!.alpha = 0
                                }, completion: {
                                    (value: Bool) in
                                    var textStyle = [NSObject : AnyObject]()
                                    var paragraphStyle = NSMutableParagraphStyle()
                                    paragraphStyle.alignment = NSTextAlignment.Center
                                    
                                    textStyle[NSForegroundColorAttributeName] = DreamRightSK.color
                                    textStyle[NSFontAttributeName] = UIFont(name: "Optima-Regular", size: 20)!
                                    textStyle[NSParagraphStyleAttributeName] = paragraphStyle
                                    
                                    let doneText = NSAttributedString(string: "Done", attributes: textStyle)
                                    self.rightLabel!.attributedText = doneText
                            })
                            
                            UIView.animateWithDuration(0.2, delay: 0.2, options: nil, animations: {
                                self.rightLabel!.alpha = 1
                                }, completion: nil)
                        }
                    }
                }
                else if navState == 2 {
                    for view in self.view.subviews {
                        if let box = view as? DreamBox {
                            navState = 1
                            
                            box.editJiggle(false)
                            
                            UIView.animateWithDuration(0.2, animations: {
                                self.rightLabel!.alpha = 0
                                }, completion: {
                                    (value: Bool) in
                                    var textStyle = [NSObject : AnyObject]()
                                    var paragraphStyle = NSMutableParagraphStyle()
                                    paragraphStyle.alignment = NSTextAlignment.Center
                                    
                                    textStyle[NSForegroundColorAttributeName] = DreamRightSK.color
                                    textStyle[NSFontAttributeName] = UIFont(name: "Optima-Regular", size: 20)!
                                    textStyle[NSParagraphStyleAttributeName] = paragraphStyle
                                    
                                    let doneText = NSAttributedString(string: "Edit", attributes: textStyle)
                                    self.rightLabel!.attributedText = doneText
                            })
                            
                            UIView.animateWithDuration(0.2, delay: 0.2, options: nil, animations: {
                                self.rightLabel!.alpha = 1
                                }, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
