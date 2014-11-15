//
//  LogViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/8/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

// MARK: - Contants

let titleCellFrame = CGRect(x: 12.0, y: 8.0, width: 250, height: 24.0)
let dateCellFrame = CGRect(x: 12.0, y: 38.0, width: 250, height: 20.0)

let borderColor = DreamRightSK.color2.CGColor
let borderWidth = 0.8
let cornerRadius = 8

// MARK: - Data Structures

// Provides the structure for a single night's information
// This information includes an array of dream structures
struct LogEntry {
    var date: NSDate
    var name: String
    var tags: [String]
    var dreams: [LogDream]
    var isHidden: Int
}

// Provides the structure for a single dream
struct LogDream {
    var recording: NSData?
    var name: String
    var description: String
    var time: NSDate
    var tags: [String]
}

// MARK: - Subclassed UIViewControllers

// The main collection view manager - this embedded in one of LogContainerView's containers
class LogViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var entries: [LogEntry]?
    var parent: LogContainer?
    
    // MARK: - UIViewController overrides
    
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
                var dreamDescription = "Original Description #\(x * y)"
                var dreamTags = ["tag2"]
                
                for x in 0...50 {
                    dreamDescription += "MOARMOARMOAR"
                }
                
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

    // Don't present the layout until we are loaded - this allows for a nice fade
    override func viewDidAppear(animated: Bool) {
        self.collectionView.setCollectionViewLayout(SpringyFlow(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - UICollectionView Delegates
    
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
        // Use an existing prototype cell - customized in the LogCell subclass
        let myCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("logCell", forIndexPath: indexPath) as LogCell
        
        var curEntry = entries![indexPath.row]
        // Apply the formatting to the entry's date
        let dateString = dateToNightText(curEntry.date)
        
        // Populate the UI
        myCell.lblDate.text = dateString
        myCell.lblDreamCount.text = "\(curEntry.dreams.count)"
        myCell.lblNightName.text = curEntry.name
        
        // Configure the cell (border color, width, corner radius)
        if !myCell.configured {
            myCell.configure()
        }
        
        return myCell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Obtain the selected cell's attributes
        let cellAttributes = self.collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        
        // Convert the selected cell's frame from the context of the collection to the context of the main view
        var cellFrame = self.collectionView.convertRect(cellAttributes!.frame, toView: self.view)
        
        // Get the current selection from our night log array
        let nightEntry = entries![indexPath.row]
        let dreams = nightEntry.dreams
        
        // Prepare an array of DreamBoxes (UIViews similar in design to LogCell)
        var dreamBoxes = [DreamSuperBox]()
        
        // Loop through each dream entry for the current night
        for x in 0...nightEntry.dreams.count {
            // Create a DreamBox with the same frame as the selected cell
            var box: DreamSuperBox?
            
            if x == 0 {
                let title = nightEntry.name
                let date = dateToNightText(nightEntry.date)
                
                box = DreamSuperBox(frame: cellFrame, title: title, date: date, body: nil)
                box?.fadeInViews(0)
            }
            else {
                let dreamName = dreams[x - 1].name
                let dreamTime = dateToDreamText(dreams[x - 1].time)
                let dreamBody = dreams[x - 1].description
                
                box = DreamSuperBox(frame: cellFrame, title: dreamName, date: dreamTime, body: dreamBody)
            }
            
            // Add the new box to our array of DreamBoxes
            dreamBoxes.append(box!)
            
            // Add the DreamBox to our parent (the LogContainerView)
            self.parent!.view.addSubview(box!)
        }
        
        // Save a reference to the UICollectionView so that we can show it again later
        self.parent!.dreamCollection = self.collectionView
        
        // Fade away the UICollectionView
        UIView.animateWithDuration(0.5, animations: {
            self.collectionView.alpha = 0
        })
        
        // Begin to animate the navigation bar
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            // Get a handle on the navContainer and its subview
            var navContainer = self.parent!.navContainer!
            var subNav = self.parent!.subNav!
            
            // Slide the nav subview down to hide it
            subNav.frame = CGRect(x: 0, y: navContainer.frame.height, width: navContainer.frame.width, height: 0)
            }, completion: {
                (value: Bool) in
                // Once
                self.parent!.singleLabel?.hidden = true
    
                self.parent!.leftLabel?.hidden = false
                self.parent!.rightLabel?.hidden = false
                self.parent!.divider?.hidden = false
                
                self.parent!.navState = 1
        })
        
        
        // Animate the altered navigation bar back into view
        UIView.animateWithDuration(0.7, delay: 0.3, usingSpringWithDamping: 0.52, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            // Get navigation bar handles from the container parent
            var navContainer = self.parent!.navContainer!
            var subNav = self.parent!.subNav!
            
            // Bring the navigation to its proper resting point
            subNav.frame = CGRect(x: 0, y: 0, width: navContainer.frame.width, height: navContainer.frame.height)
            }, completion: nil)
        
        // Loop through each of our newly generated boxes
        for x in 0...dreamBoxes.count - 1 {
            var contextFrame = dreamBoxes[x].frame
            
            var finalFrame = CGRect()
            
            // The first box stays the same - the night info box
            if x == 0 {
                finalFrame = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: 66)
            }
            else {
                // Calculate the proper dimensions to fit x boxes on the screen
                let boxCount: CGFloat = CGFloat(dreamBoxes.count - 1)
                let boxWidth = self.view.frame.width - 20
                let boxHeight = (self.view.frame.height - 86) / boxCount - 10
                let boxY = 76 + CGFloat(x - 1) * boxHeight + CGFloat(10 * x)
                let boxX: CGFloat = 10
                
                finalFrame = CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight)
            }
            
            // Slight delay for each subsequent box
            let delayTime = Double(x) * 0.08
            
            // Animate each of the boxes to their final location
            UIView.animateWithDuration(0.4, delay: 0.15 + delayTime, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                dreamBoxes[x].frame = finalFrame
                dreamBoxes[x].fadeInViews(0.15)
                }, completion: {
                    (value: Bool) in
            })
        }
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
        
        // Initialize the dynamic animator - the lifeblood of SpringyFlow
        if dynamicAnimator == nil {
            dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        }
        
        // Configure misc cell variables
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.itemSize = CGSizeMake(self.collectionView!.frame.width - 20, 66);
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        // Cast layout attributes as dynamic items
        let contentSize = self.collectionView!.contentSize
        let items = super.layoutAttributesForElementsInRect(CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)) as? [UIDynamicItem]
        
        // Only configure these dynamic behaviors once
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
    
    // Defer to the dynamic animator
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        return dynamicAnimator?.itemsInRect(rect)
    }
    
    // Defer to the dynamic animator
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        return dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    // Configure this directly
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        // Detect the location of the touch, the item being touched and the speed of the drag
        let scrollView = self.collectionView
        let delta = newBounds.origin.y - scrollView!.bounds.origin.y
        let touchLocation = self.collectionView!.panGestureRecognizer.locationInView(self.collectionView)
        let behaviours = dynamicAnimator!.behaviors as [UIAttachmentBehavior]
        
        // Examine each behaviour (essentially each cell)
        for behaviour in behaviours {
            // Calculate how far the current touch is from the cell's anchor point
            let yDistanceFromTouch = touchLocation.y - behaviour.anchorPoint.y
            // 1380 was determined by trial and error - higher numbers mean tighter "springs"
            let scrollResistance: CGFloat = (yDistanceFromTouch) / 1380
            
            let item = behaviour.items.first as UICollectionViewLayoutAttributes
            var center = item.center
            
            // Determine the new center for the item based on the variables above
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
            
            // Apply the change
            item.center = center
            dynamicAnimator?.updateItemUsingCurrentState(item)
        }
        
        // We've just done this programatically
        return false
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
    
    // Set up the log cell
    func configure() {
        self.layer.borderColor = DreamRightSK.color2.CGColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 8
        
        configured = true
    }
}

// MARK: - Custom UIView for zooming in to dream detail

class DreamSuperBox: UIView {
    var dreamView: DreamBox?
    
    var title: String?
    var date: String?
    var body: String?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, title: String, date: String, body: String?) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
        // Configure the view properly
        self.layer.borderColor = DreamRightSK.color2.CGColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 8
        
        // Load our nib
        dreamView = UIView.initWithNibName("DreamView") as DreamBox
        dreamView?.frame = self.bounds
        
        // Add the DreamView
        self.addSubview(dreamView!)
        
        // Configure the DreamView
        dreamView?.lblDate.text = date
        dreamView?.lblTitle.text = title
        
        if let txt = body {
            dreamView?.txtDescription.text = body
        }
        else {
            dreamView?.txtDescription.hidden = true
        }
    }
    
    override func layoutSubviews() {
        dreamView!.lblTitle.frame = titleCellFrame
        dreamView!.lblDate.frame = dateCellFrame
        dreamView!.bounds = self.bounds
        dreamView!.txtDescription.setContentOffset(CGPointZero, animated: true)
    }
    
    func fadeInViews(wait: Double) {
        delay(wait, {
            UIView.animateWithDuration(0.5, animations: {
                self.dreamView!.lblTitle.alpha = 1.0
                self.dreamView!.txtDescription.alpha = 1.0
                self.dreamView!.lblDate.alpha = 1.0
            })
        })
    }
    
    // Start and stop the edit indicating jiggles
    func editJiggle(start: Bool) {
        // Remove existing animations if !start
        if !start {
            self.layer.removeAllAnimations()
            return
        }
        
        // Grab the current frame and origin
        let curFrame = self.frame
        let curOrigin = curFrame.origin
        
        // Create the animation and configure the wobble angle (radians)
        let animation = CAKeyframeAnimation(keyPath: "transform")
        let wobbleAngle = CGFloat(0.013)
        
        // Wobble to left now, wobble to the right ya'll
        let left = NSValue(CATransform3D: CATransform3DMakeRotation(wobbleAngle, 0, 0, 1))
        let right = NSValue(CATransform3D: CATransform3DMakeRotation(-wobbleAngle, 0, 0, 1))
        
        // Configure the animation
        animation.values = [left, right]
        animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        animation.autoreverses = true
        animation.duration = 0.13
        animation.repeatCount = HUGE
        
        // Add the animation to our layer (starts immediately)
        self.layer.addAnimation(animation, forKey: "transform")
    }
}

class DreamBox: UIView {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var txtDescription: UITextView!
    @IBOutlet var constraintTitleDate: NSLayoutConstraint!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Called after the IBOutlets have been hooked up
    override func awakeFromNib() {
        self.txtDescription.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
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
        
        // Configure the navigation bar and present the navigation bar
        prepareNav()
        presentNav()
    }
    
    // Do a little itty bitty lil springy pop up ~
    func presentNav() {
        let navFrame = navContainer.frame
        let newFrame = CGRect(x: 0, y: 0, width: navFrame.width, height: navFrame.height)
        
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.52, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            self.subNav!.frame = newFrame
            }, completion: nil)
    }
    
    // Configure the navigation bar
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
//        else if segue.identifier == "logNavSegue" {
//            let logVC = segue.destinationViewController as LogContainer
//        }
    }
    
    func navTap(gesture: UITapGestureRecognizer) {
        // The default state - returns to the home screen
        if navState == 0 {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        // Detail view state - 1 is standard and 2 is editing
        else if navState == 1 || navState == 2 {
            // Create rectangles for each side of the button
            let leftRec = CGRect(x: 0, y: 0, width: subNav!.frame.width / 2, height: subNav!.frame.height)
            let rightRec = CGRect(x: subNav!.frame.width / 2, y: 0, width: subNav!.frame.width / 2, height: self.subNav!.frame.height)
            
            // Check if the tap came into the left rectangle (Back)
            if CGRectContainsPoint(leftRec, gesture.locationOfTouch(0, inView: subNav!)) {
                navState = 0 // Transfer back to default state
                
                // Remove all DreamBoxes (we'll miss you guys!)
                for view in self.view.subviews {
                    if let box = view as? DreamSuperBox {
                        box.removeFromSuperview()
                    }
                }
                
                // Fade the collectionView back into reality
                UIView.animateWithDuration(0.9, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.dreamCollection.alpha = 1
                }, completion: nil)
                
                // Let's get ready to rumble - pop that nav bar down boys!
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.subNav!.frame = CGRect(x: 0, y: self.navContainer.frame.height, width: self.navContainer.frame.width, height: 0)
                    }, completion: {
                        (value: Bool) in
                        // Once the nav bar is hidden swap buttons out
                        self.singleLabel?.hidden = false
                        
                        self.leftLabel?.hidden = true
                        self.rightLabel?.hidden = true
                        self.divider?.hidden = true
                        
                        // Change the Done text back to Edit if needed
                        var textStyle = [NSObject : AnyObject]()
                        var paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = NSTextAlignment.Center
                        
                        textStyle[NSForegroundColorAttributeName] = DreamRightSK.color
                        textStyle[NSFontAttributeName] = UIFont(name: "Optima-Regular", size: 20)!
                        textStyle[NSParagraphStyleAttributeName] = paragraphStyle
                        
                        let doneText = NSAttributedString(string: "Edit", attributes: textStyle)
                        self.rightLabel!.attributedText = doneText
                })
                
                // Springy pop that sucker right back up
                UIView.animateWithDuration(0.7, delay: 0.3, usingSpringWithDamping: 0.52, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.subNav!.frame = CGRect(x: 0, y: 0, width: self.navContainer.frame.width, height: self.navContainer.frame.height)
                    }, completion: nil)
            }
            // Otherwise we're on the right side (Edit)
            else if CGRectContainsPoint(rightRec, gesture.locationOfTouch(0, inView: subNav!)) {
                // Transition from detail view (not editing) to detail view (editing)
                if navState == 1 {
                    // Turn on the jiggle for all of our DreamBoxes
                    for view in self.view.subviews {
                        if let box = view as? DreamSuperBox {
                            navState = 2
                            
                            box.editJiggle(true)
                            
                            // Swap out the Edit button with Done
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
                // Transition from detail view (editing) back to detail view (not editing)
                else if navState == 2 {
                    // Turn off all the jiggles
                    for view in self.view.subviews {
                        if let box = view as? DreamSuperBox {
                            navState = 1
                            
                            box.editJiggle(false)
                            
                            // Swap the label text again
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
