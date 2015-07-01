//
//  DreamViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/8/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

// MARK: - Constants

// Max and min # of stars involved in the burst
let minStars = 18
let maxStars = 22

// Max and min star size
let minSize: CGFloat = 12
let maxSize: CGFloat = 42

// Star animation max and min
let minAnimationDelay: CGFloat = 0
let maxAnimationDelay: CGFloat = 0

// Angular velocity max and min
let minAngularVelocity: CGFloat = 3.0
let maxAngularVelocity: CGFloat = 1.0

// Burst direction max and min
let minDirection: CGFloat = 10
let maxDirection: CGFloat = 151
let minHeight: CGFloat = 340
let maxHeight: CGFloat = 610

// Time to grow, bring alpha to 1/0 and initial start scale
let growthTime = 1.1
let fadeInTime = 0.4
let fadeDelay = 0.25
let fadeOutTime = 0.65
let scale: CGFloat = 3.5

class BurstView: UIView {
    var stars = [UIImageView]()
    var animator: UIDynamicAnimator!
    let gravity = UIGravityBehavior()
    let velocityAndShit = UIDynamicItemBehavior()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        animator = UIDynamicAnimator(referenceView: self)
        
        self.animator.addBehavior(gravity)
        self.animator.addBehavior(velocityAndShit)
    }
    
    func addImage(image: UIImage, center: CGPoint) {
        let imageView = UIImageView(image: image)
        let size = imageView.frame.width
        let location = CGPoint(x: center.x - size / 2, y: center.y - size / 2)
        
        self.addSubview(imageView)
        self.sendSubviewToBack(imageView)
        self.stars.append(imageView)
        
        imageView.frame = CGRect(origin: location, size: CGSize(width: size, height: size))
        imageView.alpha = 0.0
//        animator = UIDynamicAnimator(referenceView: self)
//        
//        self.animator.addBehavior(gravity)
//        self.animator.addBehavior(velocityAndShit)
    }
    
    func explode() {
        for star in stars {
            let curDelay = Double(randomFloatBetweenNumbers(minAnimationDelay, secondNum: maxAnimationDelay))
            var curAngularity = randomFloatBetweenNumbers(minAngularVelocity, secondNum: maxAngularVelocity)
            let curHeight = -randomFloatBetweenNumbers(minHeight, secondNum: maxHeight)
            var curLinearity = CGPoint(x: randomFloatBetweenNumbers(minDirection, secondNum: maxDirection), y: curHeight)
            
            if randomIntBetweenNumbers(0, secondNum: 10) % 2 == 1 {
                curAngularity = -curAngularity
            }
            
            if randomIntBetweenNumbers(0, secondNum: 10) % 2 == 1 {
                curLinearity = CGPoint(x: -curLinearity.x, y: curHeight)
            }
            
            delay(curDelay, closure: {
                // Set up the gravitronator
                self.gravity.addItem(star)
                self.velocityAndShit.addItem(star)
                self.velocityAndShit.addAngularVelocity(curAngularity, forItem: star)
                self.velocityAndShit.addLinearVelocity(curLinearity, forItem: star)
                
                star.transform = CGAffineTransformIdentity
                
                UIView.animateWithDuration(growthTime, delay: 0.0, options: [], animations: {
                    star.transform = CGAffineTransformMakeScale(scale, scale)
                    }, completion: nil)
                
                UIView.animateWithDuration(fadeInTime, delay: 0.0, options: [], animations: {
                    star.alpha = 1.0
                    }, completion: {
                        (value: Bool) in
                        UIView.animateWithDuration(fadeOutTime, delay: fadeDelay, options: [], animations: {
                            star.alpha = 0.0
                            }, completion: nil)
                })
            })
        }
        
        // Wait 2 seconds till we're sure the stars are offscreen
        delay(2.0, closure: {
            self.removeFromSuperview()
        })
    }
}

// Visualizer constants
let gain: Float = 1.77
let roll: Int32 = 420
let visualizerHeight: CGFloat = 120

// Recording constants
let minLength: NSTimeInterval = 10
let recordTextAnimLength: NSTimeInterval = 1.3

class DreamViewController: UIViewController, UIGestureRecognizerDelegate, EZMicrophoneDelegate {
    // View for instructions
    var detailView: DetailView!
    var exitView: ExitSuperView!
    var detailShown = false
    var exitShown = false
    var exitState = 0
    var unicornCount = 0
    
    // Star container for initial burst
    var burstViews = [BurstView]()
    
    // Animator and gravity generator
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    
    // Misc audio shenanigans
    var visualizer: EZAudioPlotGL!
    var visualizerMask: UIView!
    var microphone: EZMicrophone!
    var recordingStart: NSDate?
    var savingDream = false
    
    var theNight: Night!
    
    // Lukas's unicorn
    @IBOutlet var imgUnicorn: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPress:")
        longPress.minimumPressDuration = 0.0
        
        self.view.addGestureRecognizer(longPress)
        
        let detailFrame = CGRect(x: self.view.frame.width - 50, y: self.view.frame.height - 50, width: 40, height: 40)
        detailView = DetailView(frame: detailFrame)
        exitView = ExitSuperView(frame: self.view.frame, backgroundColor: self.view.backgroundColor!, parent: self)
        
        imgUnicorn.frame = CGRect(x: self.view.frame.width / 2 - 89, y: self.view.frame.height, width: 178, height: 178)
        
        self.view.addSubview(exitView)
        self.view.addSubview(detailView)
        
        // Create the current night object if needed
        let nights = getObjects("Night", predicate: nil) as! [Night]
        var recentNight = nights[0].date
        
        // Get the most recent night
        for night in nights {
            if night.date?.timeIntervalSinceDate(recentNight!) < 0 {
                recentNight = night.date
            }
        }
        
        // Get time interval from previous 3 PM
        let rightNow = NSDate()
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let nowComponents = calendar?.component(NSCalendarUnit.Hour, fromDate: <#T##NSDate#>)
        
        
        let dateComponents = NSDateComponents()
        dateComponents.day
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:6];
        [comps setMonth:5];
        [comps setYear:2004];
        NSCalendar *gregorian = [[NSCalendar alloc]
        initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [gregorian dateFromComponents:comps];
        [comps release];
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        // Extract date components into components1
        NSDateComponents *components1 = [gregorianCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
        fromDate:date1];
        
        // Extract time components into components2
        NSDateComponents *components2 = [gregorianCalendar components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
        fromDate:date2];
        
        // Combine date and time into components3
        NSDateComponents *components3 = [[NSDateComponents alloc] init];
        
        [components3 setYear:components1.year];
        [components3 setMonth:components1.month];
        [components3 setDay:components1.day];
        
        [components3 setHour:components2.hour];
        [components3 setMinute:components2.minute];
        [components3 setSecond:components2.second];
        
        // Generate a new NSDate from components3.
        NSDate *combinedDate = [gregorianCalendar dateFromComponents:components3];
        
        if recentNight?.timeIntervalSinceDate(tonight) > (60 * 60 )
        
        
        print(nights)
    }
    
    override func viewWillAppear(animated: Bool) {
        initVisualizer()
        
        visualizerMask = UIView(frame: visualizer.frame)
        visualizerMask.frame.origin = CGPoint(x: -self.view.frame.width, y: 0)
        visualizerMask.backgroundColor = self.view.backgroundColor
        
        microphone = EZMicrophone(delegate: self, startsImmediately: true)
        self.visualizerMask.frame.origin = CGPointZero
        
        self.view.addSubview(visualizerMask)
    }
    
    override func viewDidAppear(animated: Bool) {
        microphone.stopFetchingAudio()
        visualizer.clear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVisualizer() {
        for view in self.view.subviews {
            if let curView = view as? EZAudioPlotGL {
                curView.removeFromSuperview()
            }
        }
        
        visualizer = EZAudioPlotGL(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: visualizerHeight))
        visualizer.plotType = EZPlotType.Rolling
        visualizer.backgroundColor = self.view.backgroundColor
        visualizer.color = DreamRightSK.yellow
        visualizer.gain = gain
        visualizer.shouldFill = false
        visualizer.shouldMirror = true
        visualizer.setRollingHistoryLength(roll)
        
        self.view.addSubview(visualizer)
        
        if visualizerMask != nil {
            self.view.sendSubviewToBack(visualizerMask)
        }
        
        self.view.sendSubviewToBack(visualizer)
    }
    
    func showUnicorn() {
        delay(0.5, closure: {
            let size = self.imgUnicorn.frame.size
            let newY = self.view.frame.height - 178
            let sameX = self.view.frame.width / 2 - 89
            let newPoint = CGPoint(x: sameX, y: newY)
            
            UIView.animateWithDuration(0.9, delay: 0.0, usingSpringWithDamping: 0.47, initialSpringVelocity: 0.0, options: [], animations: {
                self.imgUnicorn.frame = CGRect(origin: newPoint, size: size)
                }, completion: nil)
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // A single tap will start recording
    func longPress(gesture: UILongPressGestureRecognizer) {
        // Save the gesture point
        let gesturePoint = gesture.locationInView(self.view)
        
        if savingDream {
            return
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            if exitState == 1 {
                exitState = 0
                exitView.transitionMask(true)
                return
            }
        }
        
        // If this is the first tap...
        if gesture.state == UIGestureRecognizerState.Began {
            if detailShown {
                detailView.transition(false)
                detailShown = false
                
                if CGRectContainsPoint(exitView.normalView.frame, gesturePoint) {
                    exitView.transition(true)
                    exitShown = true
                    
                    unicornCount++
                    
                    if unicornCount == 4 {
                        unicornCount = 0
                        showUnicorn()
                    }
                }
                
                return
            }
            
            if exitShown {
                if !CGRectContainsPoint(exitView.normalView.frame, gesturePoint) {
                    exitView.transition(false)
                    exitShown = false
                    
                    if CGRectContainsPoint(detailView.frame, gesturePoint) {
                        detailView.transition(true)
                        detailShown = true
                        
                        unicornCount++
                        
                        if unicornCount == 4 {
                            unicornCount = 0
                            showUnicorn()
                        }
                    }
                    
                    return
                }
                
                exitState = 1
                exitView.transitionMask(false)
                
                return
            }
            
            if CGRectContainsPoint(detailView.frame, gesturePoint) {
                detailView.transition(true)
                detailShown = true
                
                unicornCount = 0
                
                return
            }
            
            if CGRectContainsPoint(exitView.normalView.frame, gesturePoint) {
                exitView.transition(true)
                exitShown = true
                
                unicornCount = 0
                
                return
            }
            
            // Switch the microphone on or off
            if !microphone.microphoneOn {
                // Create the new view
                let starView = BurstView(frame: self.view.frame)
                
                // Create each of the stars
                for _ in 0...randomIntBetweenNumbers(minStars, secondNum: maxStars) {
                    // Calculate frame and generate star
                    let curSize = randomFloatBetweenNumbers(minSize, secondNum: maxSize)
                    let curRect = CGRect(origin: CGPointZero, size: CGSize(width: curSize, height: curSize))
                    let curStar = DreamRightSK.imageOfLoneStar(curRect)
                    
                    starView.addImage(curStar, center: gesturePoint)
                }
                
                // Burst each of the stars out
                self.view.addSubview(starView)
                starView.explode()
                
                recordingStart = NSDate()
                microphone.startFetchingAudio()
                
                delay(0.1, closure: {
                    self.visualizerMask.frame.origin = CGPoint(x: -self.view.frame.width, y: 0)
                })
                
                // Create persistent object
                let test = Dream()
            }
            else {
                stopMic()
            }
        }
    }
    
    func beginSave() {
        
    }
    
    func stopMic() {
        savingDream = true
        
        let recordingEnd = NSDate()
        var recordLength: NSTimeInterval = 0
        
        if recordingStart != nil {
            recordLength = recordingEnd.timeIntervalSinceDate(recordingStart!)
        }
        
        let infoLabel = UILabel()
        infoLabel.textColor = DreamRightSK.yellow
        infoLabel.font = UIFont.systemFontOfSize(25)
        
        if recordLength < minLength {
            infoLabel.text = "Dream Discarded"
        }
        else {
            infoLabel.text = "Dream Saved"
        }
        
        infoLabel.sizeToFit()
        
        let infoHeight = infoLabel.frame.height
        let infoWidth = infoLabel.frame.width
        let newFrame = CGRect(x: self.view.frame.width / 2 - infoWidth / 2, y: self.view.frame.height / 2 - infoHeight / 2, width: infoWidth, height: infoHeight)
        
        infoLabel.frame = newFrame
        infoLabel.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        self.view.addSubview(infoLabel)
        
        UIView.animateWithDuration(recordTextAnimLength, animations: {
            infoLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5)
            infoLabel.alpha = 0.0
            }, completion: {
                (value: Bool) in
                infoLabel.removeFromSuperview()
                self.savingDream = false
        })
        
        UIView.animateWithDuration(0.8, animations: {
            self.visualizerMask.frame.origin = CGPointZero
            }, completion: {
                (value: Bool) in
                self.microphone.stopFetchingAudio()
                self.initVisualizer()
        })
    }
    
    func initiateExit() {
        exitState = 2
        
        detailView.dismiss()
        exitView.dismiss()
        
        stopMic()
        
//        let starView = BurstView(frame: self.view.frame)
//        
//        for _ in 0...randomIntBetweenNumbers(minStars, secondNum: maxStars) {
//            // Calculate frame and generate star
//            let curSize = randomFloatBetweenNumbers(minSize, secondNum: maxSize)
//            let curRect = CGRect(origin: CGPointZero, size: CGSize(width: curSize, height: curSize))
//            let curStar = DreamRightSK.imageOfLoneStar(curRect)
//            
//            starView.addImage(curStar, center: CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2))
//        }
//        
//        self.view.addSubview(starView)
//        
//        delay(0.3, closure: {
//            starView.explode()
//        })
//        
        delay(0.8, closure: {
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue(), {
            self.visualizer.updateBuffer(buffer[0], withBufferSize: bufferSize)
        })
    }
}

// Dismissal constants
let dismissDuration: NSTimeInterval = 0.8
let dismissDamping: CGFloat = 0.52
let dismissVelocity: CGFloat = 0.0

class DetailView : UIView {
    @IBOutlet var detailView: UIView!
    @IBOutlet var lblQuestionMark: UILabel!
    @IBOutlet var lblInfo: UILabel!
    
    var detailShown = false
    var detailTransition = false
    
    // Border constants
    let borderColor = DreamRightSK.yellow.CGColor
    let borderWidth: CGFloat = 0.8
    let cornerRadius: CGFloat = 8
    
    // Animation constants
    let fadeDuration: NSTimeInterval = 0.23
    let expandDuration: NSTimeInterval = 0.53
    let expandDamping: CGFloat = 0.79
    
    // Padding constants
    let verticalHeight: CGFloat = 80
    let horizontalPadding: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        // Set up the rounded frame
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        
        // Don't let our xib view bleed out
        self.clipsToBounds = true
        
        // Load up our xib and add the view
        NSBundle.mainBundle().loadNibNamed("DreamInstruction", owner: self, options: nil)
        
        detailView.frame = self.bounds
        detailView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        self.addSubview(detailView)
    }
    
    override func layoutSubviews() {
        detailView.frame = self.bounds
    }
    
    func transition(expand: Bool) {
        // Get our main view's size
        let superSize = self.superview!.frame.size
        
        // Configure variables for animation
        var newFrame = CGRect(x: horizontalPadding, y: superSize.height / 2 - verticalHeight / 2, width: superSize.width - horizontalPadding * 2, height: verticalHeight)
        var fadeIn = lblInfo
        var fadeOut = lblQuestionMark
        
        // Swap things out if we're contracting
        if !expand {
            newFrame = CGRect(x: superSize.width - 50, y: superSize.height - 50, width: 40, height: 40)
            fadeIn = lblQuestionMark
            fadeOut = lblInfo
        }
        
        // Fade out the text and follow up a springy frame update
        UIView.animateWithDuration(fadeDuration, animations: {
            fadeOut.alpha = 0
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(self.expandDuration, delay: 0.0, usingSpringWithDamping: self.expandDamping, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.frame = newFrame
                    }, completion: nil)})
        
        // Fade the text back in when the frame update is complete
        UIView.animateWithDuration(fadeDuration, delay: fadeDuration + expandDuration, options: [], animations: {
            fadeIn.alpha = 1
            }, completion: {
                (value: Bool) in
                self.detailShown = !self.detailShown
        })
    }
    
    func dismiss() {
        // Get our main view's size
        let superSize = self.superview!.frame.size
        
        // Fade out the text and follow up a springy frame update
        UIView.animateWithDuration(fadeDuration, animations: {
            self.lblQuestionMark.alpha = 0.0
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(dismissDuration, delay: 0.0, usingSpringWithDamping: dismissDamping, initialSpringVelocity: dismissVelocity, options: [], animations: {
                    self.frame = CGRect(x: superSize.width - 25, y: superSize.height - 25, width: 0, height: 0)
                    }, completion: nil)})
    }
}

class ExitSuperView: UIView {
    var normalView: ExitView!
    var invertedView: ExitView!
    var parent: DreamViewController!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, backgroundColor: UIColor, parent: DreamViewController) {
        super.init(frame: frame)
        
        let exitFrame = CGRect(x: 10, y: self.frame.height - 50, width: 40, height: 40)
        self.backgroundColor = UIColor.clearColor()
        self.parent = parent
        
        normalView = ExitView(frame: exitFrame, masked: false, superSize: self.frame.size, superColor: backgroundColor)
        invertedView = ExitView(frame: exitFrame, masked: true, superSize: self.frame.size, superColor: backgroundColor)
        
        self.addSubview(normalView)
        self.addSubview(invertedView)
    }
    
    func detailShown() -> Bool {
        return normalView!.detailShown
    }
    
    func transition(expand: Bool) {
        normalView!.transition(expand)
    }
    
    func transitionMask(maskOn: Bool) {
        invertedView!.transitionMask(maskOn)
    }
    
    func initiateExit() {
       parent.initiateExit()
    }
    
    func dismiss() {
        normalView.dismiss()
        invertedView.dismiss()
    }
}

class ExitView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var lblPrompt: UILabel!
    @IBOutlet var lblX: UILabel!
    
    // Padding constants
    let verticalHeight: CGFloat = 80
    let horizontalPadding: CGFloat = 40
    
    // Border constants
    let borderColor = DreamRightSK.yellow.CGColor
    let borderWidth: CGFloat = 0.8
    let cornerRadius: CGFloat = 8
    
    // Animation constants
    let fadeDuration: NSTimeInterval = 0.23
    let expandDuration: NSTimeInterval = 0.53
    let expandDamping: CGFloat = 0.79
    let showMask: CGFloat = 1.5
    let hideMask: CGFloat = 0.8
    
    // Mask variables
    var hasMask = false
    var curMasked = true
    var detailShown = false
    var mask: CAGradientLayer?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, masked: Bool, superSize: CGSize, superColor: UIColor) {
        super.init(frame: frame)
        
        // Set up the rounded frame
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        
        // Don't let our xib view bleed out
        self.clipsToBounds = true
        
        // Load up our xib and add the view
        NSBundle.mainBundle().loadNibNamed("DreamQuit", owner: self, options: nil)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        
        if masked {
            hasMask = true
            
            let newFrame = CGRect(x: horizontalPadding, y: superSize.height / 2 - verticalHeight / 2, width: superSize.width - horizontalPadding * 2, height: verticalHeight)
            
            self.frame = newFrame
            contentView.frame = self.bounds
            contentView.backgroundColor = DreamRightSK.yellow
            lblPrompt.textColor = superColor
            lblPrompt.alpha = 1.0
            lblX.alpha = 0.0
            
            mask = CAGradientLayer()
            
            mask!.position = CGPoint(x: -newFrame.size.width, y: 0)
            mask!.bounds = CGRect(origin: CGPoint(x: -newFrame.size.width, y: 0), size: CGSize(width: newFrame.size.width * 2, height: newFrame.size.height * 2))
            
            mask!.startPoint = CGPoint(x: 1.0, y: 1.0)
            mask!.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            let outerColor = UIColor(white: 1.0, alpha: 0.0).CGColor
            let innerColor = UIColor(white: 1.0, alpha: 1.0).CGColor
            
            mask!.colors = [outerColor, innerColor, innerColor, innerColor]
            mask!.locations = [0.0, 0.35, 0.5, 1.0]
            
            self.layer.mask = mask!
        }
        else {
            contentView.backgroundColor = superColor
            lblPrompt.alpha = 0.0
            lblX.alpha = 1.0
            lblX.textColor = DreamRightSK.yellow
            lblPrompt.textColor = DreamRightSK.yellow
        }
        
        self.addSubview(contentView)
    }
    
    func transition(expand: Bool) {
        // Get our main view's size
        let superSize = self.superview!.frame.size
        
        // Configure variables for animation
        var newFrame = CGRect(x: horizontalPadding, y: superSize.height / 2 - verticalHeight / 2, width: superSize.width - horizontalPadding * 2, height: verticalHeight)
        var fadeIn = lblPrompt
        var fadeOut = lblX
        
        // Swap things out if we're contracting
        if !expand {
            newFrame = CGRect(x: 10, y: superSize.height - 50, width: 40, height: 40)
            fadeIn = lblX
            fadeOut = lblPrompt
        }
        
        // Fade out the text and follow up a springy frame update
        UIView.animateWithDuration(fadeDuration, animations: {
            fadeOut.alpha = 0
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(self.expandDuration, delay: 0.0, usingSpringWithDamping: self.expandDamping, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
                    self.frame = newFrame
                    }, completion: nil)})
        
        // Fade the text back in when the frame update is complete
        UIView.animateWithDuration(fadeDuration, delay: fadeDuration + expandDuration, options: [], animations: {
            fadeIn.alpha = 1
            }, completion: {
                (value: Bool) in
                self.detailShown = !self.detailShown
        })
    }
    
    func transitionMask(maskOn: Bool) {
        if !hasMask {
            return
        }
        
        let curPosition = (mask!.presentationLayer()!.valueForKey("position") as! NSValue).CGPointValue()
        var newPosition = CGPoint(x: self.frame.size.width / 3, y: 0)
        let fullLength = self.frame.size.width
        var transitionTime = showMask
        
        if maskOn {
            newPosition = CGPoint(x: -self.frame.size.width, y: 0)
            transitionTime = hideMask + newPosition.x / fullLength * hideMask
        }
        
        CATransaction.begin()
        
        let revealAnimation = CABasicAnimation(keyPath: "position")
        revealAnimation.fromValue = NSValue(CGPoint: curPosition)
        revealAnimation.toValue = NSValue(CGPoint: newPosition)
        revealAnimation.duration = NSTimeInterval(transitionTime)
        
        CATransaction.setCompletionBlock({
            if !maskOn && (self.mask!.presentationLayer()!.valueForKey("position") as! NSValue).CGPointValue().x == self.frame.size.width / 3 {
                (self.superview! as! ExitSuperView).initiateExit()
            }
        })
        
        mask!.position = newPosition
        
        mask!.addAnimation(revealAnimation, forKey: "revealAnimation")
        
        CATransaction.commit()
    }
    
    func dismiss() {
        // Get our main view's size
        let superSize = self.superview!.frame.size
        
        // Fade out the text and follow up a springy frame update
        UIView.animateWithDuration(fadeDuration, animations: {
            self.lblPrompt.alpha = 0.0
            }, completion: {
                (value: Bool) in
                UIView.animateWithDuration(dismissDuration, delay: 0.0, usingSpringWithDamping: dismissDamping, initialSpringVelocity: dismissVelocity, options: [], animations: {
                    self.frame = CGRect(x: superSize.width / 2, y: superSize.height / 2, width: 0, height: 0)
                    self.alpha = 0.0
                    }, completion: nil)})
    }
}