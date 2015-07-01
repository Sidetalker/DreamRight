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

let borderColor = DreamRightSK.yellow.CGColor
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
class LogViewController: UICollectionViewController {
    var entries: [LogEntry]?
    var parent: LogContainer?
    
    // MARK: - UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the custom cell xib file
        self.collectionView?.registerNib(UINib(nibName: "LogCell", bundle: nil), forCellWithReuseIdentifier: "logCell")
        
        // Load dummy data
        entries = [LogEntry]()
        
        for x in 0...10 {
            let nightTime = NSDate(timeIntervalSinceReferenceDate: NSTimeInterval(250000 * x))
            let nightName = "Original Name #\(x)"
            var nightTags = [String]()
            
            if Int(randomFloatBetweenNumbers(1, secondNum: 2)) % 2 == 0 {
                nightTags.append("tag4")
            }
            else {
                nightTags.append("tag5")
            }
            
            var dreams = [LogDream]()
            
            for y in 0...Int(randomFloatBetweenNumbers(0, secondNum: 3)) {
                let dreamTime = NSDate(timeInterval: NSTimeInterval(1000 * y), sinceDate: nightTime)
                let dreamName = "Original Name #\(x * y)"
                var dreamDescription = "Original Description #\(x * y)"
                var dreamTags = ["tag2"]
                
                for _ in 0...50 {
                    dreamDescription += "MOARMOARMOAR"
                }
                
                if Int(randomFloatBetweenNumbers(1, secondNum: 2)) % 2 == 0 {
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
        super.viewDidAppear(animated)
//        
//        self.collectionView?.setCollectionViewLayout(SpringyFlow(), animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.setCollectionViewLayout(SpringyFlow(), animated: false)
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
        let myCell = collectionView.dequeueReusableCellWithReuseIdentifier("logCell", forIndexPath: indexPath) as! LogCell
        
        let curEntry = entries![indexPath.row]
        
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
        let cellAttributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        
        // Convert the selected cell's frame from the context of the collection to the context of the main view
        let cellFrame = collectionView.convertRect(cellAttributes!.frame, toView: self.view)
        
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
                
                box = DreamSuperBox(frame: cellFrame, title: title, date: date, body: nil, parent: self)
                box?.fadeInViews(0)
            }
            else {
                let dreamName = dreams[x - 1].name
                let dreamTime = dateToDreamText(dreams[x - 1].time)
                let dreamBody = dreams[x - 1].description
                
                box = DreamSuperBox(frame: cellFrame, title: dreamName, date: dreamTime, body: dreamBody, parent: self)
            }
            
            // Add a gesture recognizer to the box
            let tap = UITapGestureRecognizer(target: self.parent!, action: "dreamBoxTap:")
            box!.addGestureRecognizer(tap)
            
            // Add the new box to our array of DreamBoxes
            box!.parent = self
            dreamBoxes.append(box!)
            
            // Add the DreamBox to our parent (the LogContainerView)
            self.parent!.view.addSubview(box!)
        }
        
        // Inform daddy of our new DreamBoxes
        self.parent!.dreamBoxes = dreamBoxes
        
        // Save a reference to the UICollectionView so that we can show it again later
        self.parent!.dreamCollection = self.collectionView
        
        // Fade away the UICollectionView
        UIView.animateWithDuration(0.5, animations: {
            collectionView.alpha = 0
        })
        
        // Begin to animate the navigation bar
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            // Get a handle on the navContainer and its subview
            let navContainer = self.parent!.navContainer!
            let subNav = self.parent!.subNav!
            
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
            let navContainer = self.parent!.navContainer!
            let subNav = self.parent!.subNav!
            
            // Bring the navigation to its proper resting point
            subNav.frame = CGRect(x: 0, y: 0, width: navContainer.frame.width, height: navContainer.frame.height)
            }, completion: nil)
        
        // Loop through each of our newly generated boxes
        for x in 0...dreamBoxes.count - 1 {
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
                dreamBoxes[x].popInPlay(0.5 + delayTime)
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
        
        
        // BUG FIXME ERROR WHATEVER - this isn't working right like it should... seems like a bug on Apple's side
        // The collectionView frame is just wrong to start with
        self.itemSize = CGSizeMake(self.collectionView!.frame.width - 20, 66);
        
        // Window hack for the time being
//        self.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width - 20, 66)
        
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        // Cast layout attributes as dynamic items
        let contentSize = collectionViewContentSize()
        let items = super.layoutAttributesForElementsInRect(CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
        
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
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesToReturn: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElementsInRect(rect)!
        
        for attributes in attributesToReturn {
            let indexPath: NSIndexPath  = attributes.indexPath;
            attributes.frame = self.layoutAttributesForItemAtIndexPath(indexPath)!.frame
        }
        
        return attributesToReturn;
    }
    
    // Defer to the dynamic animator
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return dynamicAnimator?.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    // Configure this directly
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        // Detect the location of the touch, the item being touched and the speed of the drag
        let scrollView = self.collectionView
        let delta = newBounds.origin.y - scrollView!.bounds.origin.y
        let touchLocation = self.collectionView!.panGestureRecognizer.locationInView(self.collectionView)
        let behaviours = dynamicAnimator!.behaviors as! [UIAttachmentBehavior]
        
        // Examine each behaviour (essentially each cell)
        for behaviour in behaviours {
            // Calculate how far the current touch is from the cell's anchor point
            let yDistanceFromTouch = touchLocation.y - behaviour.anchorPoint.y
            // 1380 was determined by trial and error - higher numbers mean tighter "springs"
            let scrollResistance: CGFloat = (yDistanceFromTouch) / 1380
            
            let item = behaviour.items.first as! UICollectionViewLayoutAttributes
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
    
    // Set up the log cell
    func configure() {
        self.layer.borderColor = DreamRightSK.yellow.CGColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 8
        
        configured = true
    }
}

// MARK: - Custom UIView for zooming in to dream detail

class DreamSuperBox: UIView {
    var parent: LogViewController?
    var dreamView: DreamBox?
    
    var title: String?
    var date: String?
    var body: String?
    
    var audioDisplay: ZLSinusWaveView?
    var audioPlaying = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, title: String, date: String, body: String?, parent: LogViewController) {
        super.init(frame: frame)
        
        // Needed so that the DreamBox subview doesn't bleed out of this container
        self.clipsToBounds = true
        
        // Configure the view properly
        self.layer.borderColor = DreamRightSK.yellow.CGColor
        self.layer.borderWidth = 0.7
        self.layer.cornerRadius = 8
        
        // Save the variables
        self.title = title
        self.date = date
        self.body = body
        self.parent = parent
        
        // Load our nib
        dreamView = UIView.initWithNibName("DreamView") as DreamBox
        dreamView?.frame = self.bounds
        
        // Add the DreamView
        self.addSubview(dreamView!)
        
        // Configure the DreamView
        dreamView?.lblDate.text = date
        dreamView?.lblTitle.text = title
        
        // Make the audioView whether or not we'll use it
        let containerFrame = self.parent!.parent!.dreamContainer.frame
        
        self.audioDisplay = ZLSinusWaveView(frame: CGRect(x: containerFrame.width / 2, y: containerFrame.height - 25, width: 0, height: 0))
        audioDisplay?.backgroundColor = DreamRightSK.blue
        audioDisplay?.color = DreamRightSK.yellow
        audioDisplay?.plotType = EZPlotType.Rolling
        audioDisplay?.shouldFill = true
        audioDisplay?.shouldMirror = true
        audioDisplay?.idleAmplitude = 0.2
        audioDisplay?.frequency = 1.5
        audioDisplay?.oscillating = true
        
        // If the body text wasn't passed, hide the textfield
        if body != nil {
            dreamView?.txtDescription.text = body
        }
        else {
            dreamView?.txtDescription.hidden = true
        }
        
        if dreamView?.txtDescription.hidden != true {
            // Add tap recognizers for the dream title and description
            let titleTap = UITapGestureRecognizer(target: self.parent!.parent!, action: "dreamTitleTap:")
            let descriptionTap = UITapGestureRecognizer(target: self.parent!.parent!, action: "dreamDescriptionTap:")
            let playTap = UITapGestureRecognizer(target: self, action: "dreamPlayTap:")
            
            dreamView!.lblTitle.addGestureRecognizer(titleTap)
            dreamView!.txtDescription.addGestureRecognizer(descriptionTap)
            dreamView!.imgPlay.addGestureRecognizer(playTap)
            
            // Configure the play image
            let playImage = DreamRightSK.imageOfPlayUp(CGRect(origin: CGPointZero, size: dreamView!.imgPlay.frame.size))
            
            dreamView!.imgPlay.image = playImage
            dreamView!.imgPlay.transform = CGAffineTransformMakeScale(0.1, 0.1)
            dreamView!.imgPlay.alpha = 0.0
            
            // Add the audioDisplay to our parent's parent's frame
            self.parent!.parent!.audioDisplay = self.audioDisplay!
            EZOutput.sharedOutput().outputDataSource = self.parent!.parent!
            EZOutput.sharedOutput().startPlayback()
            self.parent!.parent!.dreamContainer.addSubview(self.audioDisplay!)
        }
        else {
            dreamView!.imgPlay.hidden = true
        }
    }
    
    override func layoutSubviews() {
        // This hardcoded hackiness is required due to some weird storyboard bug
        dreamView!.lblTitle.frame = titleCellFrame
        dreamView!.lblDate.frame = dateCellFrame
        
        // Update the bounds with the frame changes and keep the textfield at the top
        dreamView!.bounds = self.bounds
        dreamView!.txtDescription.setContentOffset(CGPointZero, animated: true)
    }
    
    // Fades in the title, description and date with a configurable delay
    func fadeInViews(wait: Double) {
        delay(wait, closure: {
            UIView.animateWithDuration(0.5, animations: {
                self.dreamView!.lblTitle.alpha = 1.0
                self.dreamView!.txtDescription.alpha = 1.0
                self.dreamView!.lblDate.alpha = 1.0
            })
        })
    }
    
    // Pops in the play button with a configurable delay
    func popInPlay(wait: Double) {
        delay(wait, closure: {
            self.dreamView!.imgPlay.alpha = 1.0
            
            UIView.animateWithDuration(0.9, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.AllowUserInteraction], animations: {
                self.dreamView!.imgPlay.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)
        })
    }
    
    // Grow visualizer
    func growVisualizer(grow: Bool) {
        let containerFrame = self.parent!.parent!.dreamContainer.frame
        
        var finalFrame = CGRectZero
        
        if grow {
            finalFrame = CGRect(x: 0, y: containerFrame.height - 55, width: containerFrame.width, height: 50)
        }
        else {
            finalFrame = CGRect(x: containerFrame.width / 2, y: containerFrame.height - 30, width: 0, height: 0)
        }
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseIn, UIViewAnimationOptions.AllowAnimatedContent], animations: {
            self.parent!.parent!.audioDisplay!.frame = finalFrame
            }, completion: {
                (value: Bool) in
                // TODO: - Audio Displa Shit here
        })
    }
    
    func dreamPlayTap(gesture: UITapGestureRecognizer) {
        if parent!.parent!.navState != 3 && parent!.parent!.navState != 4 {
            parent!.parent!.dreamBoxTap(gesture)
        }
        
        var newImage: UIImage?
        
        if audioPlaying {
            newImage = DreamRightSK.imageOfPlayUp(CGRect(origin: CGPointZero, size: dreamView!.imgPlay.frame.size))
        }
        else {
            newImage = DreamRightSK.imageOfStopUp(CGRect(origin: CGPointZero, size: dreamView!.imgPlay.frame.size))
        }
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: [], animations: {
            self.dreamView!.imgPlay.transform = CGAffineTransformMakeScale(0.1, 0.1)
            }, completion: {
                (value: Bool) in
                self.dreamView!.imgPlay.image = newImage
                self.popInPlay(0.0)
        })
        
        if audioPlaying {
            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.76, initialSpringVelocity: 0.0, options: [], animations: {
                self.frame = CGRect(x: 10, y: 10, width: self.parent!.parent!.dreamContainer.frame.width - 20, height: self.parent!.parent!.dreamContainer.frame.height - 20)
                }, completion: nil)
            
            delay(0.0, closure: {
                self.growVisualizer(false)
            })
        }
        else {
            UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.76, initialSpringVelocity: 0.0, options: [], animations: {
                self.frame = CGRect(x: 10, y: 10, width: self.parent!.parent!.dreamContainer.frame.width - 20, height: self.parent!.parent!.dreamContainer.frame.height - 70)
                }, completion: nil)
            
            delay(0.2, closure: {
                self.growVisualizer(true)
            })
        }
        
        // Flip the toggle
        audioPlaying = !audioPlaying
    }
    
    // Start and stop the edit indicating jiggles
    func editJiggle(start: Bool) {
        // Remove existing animations if !start
        if !start {
            self.layer.removeAllAnimations()
            return
        }
        
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
    
    // Start and stop the edit indicating jiggles for the current box's UIControls
    func editInnerJiggle(start: Bool) {
        // Remove existing animations if !start
        if !start {
            self.dreamView!.lblTitle.layer.removeAllAnimations()
            self.dreamView!.txtDescription.layer.removeAllAnimations()
            
            return
        }
        
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
        self.dreamView!.lblTitle.layer.addAnimation(animation, forKey: "transform")
        self.dreamView!.txtDescription.layer.addAnimation(animation, forKey: "transform")
    }
}

class DreamBox: UIView {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var txtDescription: UITextView!
    @IBOutlet var imgPlay: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Called after the IBOutlets have been hooked up
    override func awakeFromNib() {
        self.txtDescription.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        self.txtDescription.selectable = false
    }
}

// MARK: - Custom Navigation Bar

class LogNav: UIViewController {
    
}

// MARK: - Log Container View

class LogContainer: UIViewController, EZOutputDataSource {
    @IBOutlet var dreamContainer: UIView!
    @IBOutlet var navContainer: UIView!
    
    var dreamCollection: UICollectionView!
    var dreamBoxes: [DreamSuperBox]?
    
    var subNav: UIView?
    var singleLabel: UILabel?
    var leftLabel: UILabel?
    var rightLabel: UILabel?
    var divider: UIView?
    
    var navTap: UITapGestureRecognizer?
    var navState = 0
    var detailBox = -1
    var detailFrame = CGRectZero
    var audioPlaying = false
    var audioDisplay: ZLSinusWaveView?
    
    func output(output: EZOutput!, callbackWithActionFlags ioActionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>, inTimeStamp: UnsafePointer<AudioTimeStamp>, inBusNumber: UInt32, inNumberFrames: UInt32, ioData: UnsafeMutablePointer<AudioBufferList>) {
        dispatch_async(dispatch_get_main_queue()) {
            // Update the main buffer
            if let display = self.audioDisplay {
                var bufferThing: [Float] = [0, 0, 0]
                display.updateBuffer(&bufferThing, withBufferSize: 3)
            }
        }
    }
    
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
        subNav?.backgroundColor = DreamRightSK.yellow
        
        singleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: navFrame.width, height: navFrame.height))
        
        var textStyle = [String : AnyObject]()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        
        textStyle[NSForegroundColorAttributeName] = DreamRightSK.blue
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
        divider?.backgroundColor = DreamRightSK.blue
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
            let dreamSegue = segue.destinationViewController as! LogViewController
            
            dreamSegue.parent = self
        }
    }
    
    func transitionToHome() {
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
                var textStyle = [String : AnyObject]()
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = NSTextAlignment.Center
                
                textStyle[NSForegroundColorAttributeName] = DreamRightSK.blue
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
    
    // Transition from night view (not editing) to night view (editing)
    func transitionToEditA() {
        for view in self.view.subviews {
            if let box = view as? DreamSuperBox {
                navState = 2
                
                box.editJiggle(true)
                
                // Swap out the Edit button with Done
                UIView.animateWithDuration(0.2, animations: {
                    self.rightLabel!.alpha = 0
                    }, completion: {
                        (value: Bool) in
                        var textStyle = [String : AnyObject]()
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = NSTextAlignment.Center
                        
                        textStyle[NSForegroundColorAttributeName] = DreamRightSK.blue
                        textStyle[NSFontAttributeName] = UIFont(name: "Optima-Regular", size: 20)!
                        textStyle[NSParagraphStyleAttributeName] = paragraphStyle
                        
                        let doneText = NSAttributedString(string: "Done", attributes: textStyle)
                        self.rightLabel!.attributedText = doneText
                })
                
                UIView.animateWithDuration(0.2, delay: 0.2, options: [], animations: {
                    self.rightLabel!.alpha = 1
                    }, completion: nil)
            }
        }
    }
    
    // Transition from night view (editing) to night view (not editing)
    func transitionFromEditA() {
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
                        var textStyle = [String : AnyObject]()
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = NSTextAlignment.Center
                        
                        textStyle[NSForegroundColorAttributeName] = DreamRightSK.blue
                        textStyle[NSFontAttributeName] = UIFont(name: "Optima-Regular", size: 20)!
                        textStyle[NSParagraphStyleAttributeName] = paragraphStyle
                        
                        let doneText = NSAttributedString(string: "Edit", attributes: textStyle)
                        self.rightLabel!.attributedText = doneText
                })
                
                UIView.animateWithDuration(0.2, delay: 0.2, options: [], animations: {
                    self.rightLabel!.alpha = 1
                    }, completion: nil)
            }
        }
    }
    
    func transitionToEditB() {
        transitionToEditA()
        
        dreamBoxes![detailBox].editJiggle(false)
        dreamBoxes![detailBox].editInnerJiggle(true)
        
        navState = 4
    }
    
    func transitionFromEditB() {
        transitionFromEditA()
        
        dreamBoxes![detailBox].editInnerJiggle(false)
        
        navState = 3
    }
    
    // Brings us from the detail view to the night view while still in editing mode
    func transitionFromDetailB()
    {
        // But swap the jiggle
        dreamBoxes![detailBox].editInnerJiggle(false)
        dreamBoxes![detailBox].editJiggle(true)
        
        // Just a normal transition
        transitionFromDetailA()
        
        // Change back to edit state
        navState = 2
    }
    
    // Brings us from the detail view to the night view in non-editing mode
    func transitionFromDetailA() {
        let mainBox = dreamBoxes![detailBox]
        let mainY = mainBox.frame.origin.y
        var upperBoxes = [DreamSuperBox]()
        var lowerBoxes = [DreamSuperBox]()
        
        detailBox = -1
        navState = 1
        
        if mainBox.audioPlaying {
            mainBox.dreamPlayTap(UITapGestureRecognizer())
        }
        
        for box in dreamBoxes! {
            if box == mainBox {
                continue
            }
            
            let curY = box.frame.origin.y
            
            if curY > mainY {
                upperBoxes.append(box)
            }
            else {
                lowerBoxes.append(box)
            }
        }
        
        for box in upperBoxes {
            let oldFrame = box.frame
            let oldOrigin = oldFrame.origin
            let oldY = oldFrame.origin.y
            
            let width = oldFrame.width
            let height = oldFrame.height
            let x = oldOrigin.x
            let y = oldY - self.view.frame.height
            
            UIView.animateWithDuration(0.3, animations: {
                box.frame = CGRectMake(x, y, width, height)
                }, completion: {
                    (value: Bool) in
                    for box in upperBoxes {
                        box.layoutSubviews()
                    }
            })
            
            // Another hacky fix for annoying night title bug
            delay(0.01, closure: {
                for box in upperBoxes {
                    box.layoutSubviews()
                }
            })
        }
        
        for box in lowerBoxes {
            let oldFrame = box.frame
            let oldOrigin = oldFrame.origin
            let oldY = oldFrame.origin.y
            
            let width = oldFrame.width
            let height = oldFrame.height
            let x = oldOrigin.x
            let y = oldY + self.view.frame.height
            
            UIView.animateWithDuration(0.3, animations: {
                box.frame = CGRectMake(x, y, width, height)
                }, completion: {
                    (value: Bool) in
                    for box in lowerBoxes {
                        box.layoutSubviews()
                    }
            })
            
            // Another hacky fix for annoying night title bug
            delay(0.01, closure: {
                for box in lowerBoxes {
                    box.layoutSubviews()
                }
            })
        }
        
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.76, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: {
            mainBox.frame = self.detailFrame
        }, completion: nil)
    }
    
    // Triggered by tapping on the night info DreamBox at the top
    func editNightName() {
        let messageDisplay = UIAlertController(title: "Edit Night Name", message: "Rename the night", preferredStyle: UIAlertControllerStyle.Alert)
        
        messageDisplay.addTextFieldWithConfigurationHandler { textField in }
        let messageTextField = messageDisplay.textFields![0] as UITextField
        messageTextField.placeholder = "Night name"
        messageTextField.text = dreamBoxes![0].title!
        messageTextField.tag = 10
        messageTextField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
        
        messageDisplay.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {
            (alert: UIAlertAction!) in
            self.dreamBoxes![0].title = messageTextField.text
            self.dreamBoxes![0].dreamView!.lblTitle.text = messageTextField.text
        }))
        
        messageDisplay.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction!) in
            if self.dreamBoxes![0].dreamView!.lblTitle.text != self.dreamBoxes![0].title {
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.dreamBoxes![0].dreamView!.lblTitle.alpha = 0.0
                    }, completion: {
                        (value: Bool) in
                        self.dreamBoxes![0].dreamView!.lblTitle.text = self.dreamBoxes![0].title
                        
                        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                            self.dreamBoxes![0].dreamView!.lblTitle.alpha = 1.0
                            }, completion: nil)
                })
            }
        }))
        
        self.presentViewController(messageDisplay, animated: true, completion: nil)
    }
    
    // Callback to update title in realtime
    func textFieldChanged(sender: UITextField) {
        var current = detailBox
        
        if sender.tag == 10 {
            current = 0
        }
        
        if sender.text!.utf16.count >= 20 {
            sender.text = self.dreamBoxes![current].dreamView!.lblTitle.text
            return
        }
        
        self.dreamBoxes![current].dreamView!.lblTitle.text = sender.text
        
        delay(0.01, closure: {
            self.dreamBoxes![current].dreamView!.layoutSubviews()
        })
    }
    
    // Triggered by tapping on a DreamBox while in editing mode
    func transitionToDetailB(target: Int) {
        if target == 0 {
            editNightName()
            return
        }
        
        // But then switch the edit wiggle
        dreamBoxes![target].editJiggle(false)
        dreamBoxes![target].editInnerJiggle(true)
        
        // Normal transition
        transitionToDetailA(target)
        detailBox = target
        
        // And remember to change state
        navState = 4
    }
    
    // Triggered by tapping on a DreamBox
    func transitionToDetailA(target: Int) {
        // We don't want to fuck with this shit mayne
        if target == 0 {
            editNightName()
            return
        }
        
        let mainBox = dreamBoxes![target]
        let mainY = mainBox.frame.origin.y
        var upperBoxes = [DreamSuperBox]()
        var lowerBoxes = [DreamSuperBox]()
        
        detailBox = target
        detailFrame = mainBox.frame
        navState = 3
        
        for box in dreamBoxes! {
            if box == mainBox {
                continue
            }
            
            let curY = box.frame.origin.y
            
            if curY > mainY {
                upperBoxes.append(box)
            }
            else {
                lowerBoxes.append(box)
            }
        }
        
        for box in upperBoxes {
            let oldFrame = box.frame
            let oldOrigin = oldFrame.origin
            let oldY = oldFrame.origin.y
            
            let width = oldFrame.width
            let height = oldFrame.height
            let x = oldOrigin.x
            let y = oldY + self.view.frame.height
            
            UIView.animateWithDuration(0.3, animations: {
                box.frame = CGRectMake(x, y, width, height)
                })
        }
        
        for box in lowerBoxes {
            let oldFrame = box.frame
            let oldOrigin = oldFrame.origin
            let oldY = oldFrame.origin.y
            
            let width = oldFrame.width
            let height = oldFrame.height
            let x = oldOrigin.x
            let y = oldY - self.view.frame.height
            
            UIView.animateWithDuration(0.3, animations: {
                box.frame = CGRectMake(x, y, width, height)
                })
        }
        
        UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.76, initialSpringVelocity: 0.0, options: [], animations: {
            mainBox.frame = CGRectMake(10, 10, self.dreamContainer.frame.width - 20, self.dreamContainer.frame.height - 20)
        }, completion: nil)
    }
    
    func navTap(gesture: UITapGestureRecognizer) {
        // 0: Night list view (single nav button)
        // 1: Single night view (Back + Edit buttons)
        // 2: Single night view editing (Back + Done buttons)
        // 3: Detail night view (Back + Edit buttons)
        // 4: Detail night view editing (Back + Done buttons)
        
        // The default state - returns to the home screen
        if navState == 0 {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        // Night view state - 1 is standard and 2 is editing
        else if navState == 1 || navState == 2 || navState == 3 || navState == 4 {
            // Create rectangles for each side of the button
            let leftRec = CGRect(x: 0, y: 0, width: subNav!.frame.width / 2, height: subNav!.frame.height)
            let rightRec = CGRect(x: subNav!.frame.width / 2, y: 0, width: subNav!.frame.width / 2, height: self.subNav!.frame.height)
            
            // Check if the tap came into the left rectangle (Back)
            if CGRectContainsPoint(leftRec, gesture.locationOfTouch(0, inView: subNav!)) {
                if navState == 1 || navState == 2 {
                    print("transitionToHome state: \(navState)\n", appendNewline: false)
                    transitionToHome()
                    print("transitionToHome state: \(navState)\n", appendNewline: false)
                }
                else if navState == 3 {
                    print("transitionFromDetailA state: \(navState)\n", appendNewline: false)
                    transitionFromDetailA()
                    print("transitionFromDetailA state: \(navState)\n", appendNewline: false)
                }
                else if navState == 4 {
                    print("transitionFromDetailB state: \(navState)\n", appendNewline: false)
                    transitionFromDetailB()
                    print("transitionFromDetailB state: \(navState)\n", appendNewline: false)
                }
            }
            // Otherwise we're on the right side (Edit)
            else if CGRectContainsPoint(rightRec, gesture.locationOfTouch(0, inView: subNav!)) {
                if navState == 1 {
                    print("transitionToEditA state: \(navState)\n", appendNewline: false)
                    transitionToEditA()
                    print("transitionToEditA state: \(navState)\n", appendNewline: false)
                }
                // Transition from detail view (editing) back to detail view (not editing)
                else if navState == 2 {
                    print("transitionFromEditA state: \(navState)\n", appendNewline: false)
                    transitionFromEditA()
                    print("transitionFromEditA state: \(navState)\n", appendNewline: false)
                }
                else if navState == 3 {
                    print("transitionToEditB state: \(navState)\n", appendNewline: false)
                    transitionToEditB()
                    print("transitionToEditB state: \(navState)\n", appendNewline: false)
                }
                else if navState == 4 {
                    print("transitionFromEditB state: \(navState)\n", appendNewline: false)
                    transitionFromEditB()
                    print("transitionFromEditB state: \(navState)\n", appendNewline: false)
                }
            }
        }
    }
    
    func dreamBoxTap(gesture: UITapGestureRecognizer) {
        for x in 0...dreamBoxes!.count - 1 {
            let currentLocation = gesture.locationInView(self.dreamContainer)
            
            if CGRectContainsPoint(dreamBoxes![x].frame, currentLocation) {
                if navState == 1 {
                    print("transitionToDetailA state: \(navState)\n", appendNewline: false)
                    transitionToDetailA(x)
                    print("transitionToDetailA state: \(navState)\n", appendNewline: false)
                }
                else if navState == 2 {
                    print("transitionToDetailB state: \(navState)\n", appendNewline: false)
                    transitionToDetailB(x)
                    print("transitionToDetailB state: \(navState)\n", appendNewline: false)
                }
                
            }
        }
    }
    
    func dreamTitleTap(gesture: UITapGestureRecognizer) {
        for x in 0...dreamBoxes!.count - 1 {
            let currentLocation = gesture.locationInView(self.dreamContainer)
            
            if CGRectContainsPoint(dreamBoxes![x].frame, currentLocation) {
                if navState == 4 {
                    let messageDisplay = UIAlertController(title: "Edit Dream Name", message: "Rename the dream", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    messageDisplay.addTextFieldWithConfigurationHandler { textField in }
                    let messageTextField = messageDisplay.textFields![0] as UITextField
                    messageTextField.placeholder = "Dream name"
                    messageTextField.text = dreamBoxes![x].title!
                    messageTextField.tag = 20
                    messageTextField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
                    
                    messageDisplay.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {
                        (alert: UIAlertAction!) in
                        self.dreamBoxes![x].title = messageTextField.text
                        self.dreamBoxes![x].dreamView!.lblTitle.text = messageTextField.text
                    }))
                    
                    messageDisplay.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {
                        (alert: UIAlertAction!) in
                        if self.dreamBoxes![x].dreamView!.lblTitle.text != self.dreamBoxes![x].title {
                            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                                self.dreamBoxes![x].dreamView!.lblTitle.alpha = 0.0
                                }, completion: {
                                    (value: Bool) in
                                    self.dreamBoxes![x].dreamView!.lblTitle.text = self.dreamBoxes![x].title
                                    
                                    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                                        self.dreamBoxes![x].dreamView!.lblTitle.alpha = 1.0
                                        }, completion: nil)
                            })
                        }
                    }))
                    
                    self.presentViewController(messageDisplay, animated: true, completion: nil)
                }
                else {
                    dreamBoxTap(gesture)
                }
            }
        }
    }
    
    func dreamDescriptionTap(gesture: UITapGestureRecognizer) {
        for x in 0...dreamBoxes!.count - 1 {
            let currentLocation = gesture.locationInView(self.dreamContainer)
            
            if CGRectContainsPoint(dreamBoxes![x].frame, currentLocation) {
                if navState == 4 {
                    print("Edit the description", appendNewline: false)
                }
                else {
                    dreamBoxTap(gesture)
                }
            }
        }
    }
    
    // MARK: - EZMicrophone Delegate Function
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue()) {
            // Update the main buffer
            if let display = self.audioDisplay {
                display.updateBuffer(buffer[0], withBufferSize: bufferSize)
            }
        }
    }
}
