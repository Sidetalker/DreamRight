//
//  HomeViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 10/31/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

// The start screen entry ViewController
class HomeViewController: UIViewController, EZMicrophoneDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet var goToSleep: UIButton!
    @IBOutlet var seeYourDreams: UIButton!
    @IBOutlet var designTheStars: UIButton!
    
    // MARK: - Dynamic UIViews
    
    var moonContainer: UIImageView?
    var testButton: UIButton?
    
    // MARK: - Moon animation variables
    
    var moon128: UIImage?
    var moon1000: UIImage?
    var moon1500: UIImage?
    var moon3000: UIImage?
    var moonTimer: NSTimer?
    var moonCounter = 0.0
    var moonAnim = 1.5
    
    // MARK: - Decibel animation variables
    
    var decibelDisplay: ZLSinusWaveView?
    var decibelTimer: NSTimer?
    var decibelCounter: CGFloat = 0
    var microphone: EZMicrophone?
    
    // MARK: - Star animation variables
    
    var stars = [Star]()
    
    // MARK: - Button animation variables
    
    var animator: UIDynamicAnimator?
    var dreamLayer: CAShapeLayer?
    var rightLayer: CAShapeLayer?
    var dreamView: UIView?
    var rightView: UIView?
    
    // MARK: - Custom transition variables
    let transitionManager = TransitionManager()
    
    // MARK: - UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("Generating Moon Images")
        generateMoon()
        
        NSLog("Creating Star Structs")
        generateStars()
        
        NSLog("Configuring Microphone")
        configureMic()
    }
    
    // Start our animation once the view has been presented
    override func viewDidAppear(animated: Bool) {
        NSLog("Firing Timers")
        blastOffTimers()
        blowUpMoon()
        
        
        
        // Wait a bit for the moon to be totally out of sight
        delay(0.72, {
            NSLog("Adding and Twinkling Stars")
            NSLog("That's right, fucking twinkling them")
            self.twinkleStars()
            
            NSLog("Beginning Text Drawing")
            self.drawText()
            
            delay(0.3, {
                NSLog("Beginning button animation")
                
                self.animator = UIDynamicAnimator(referenceView: self.view)
                
                let myButtons = [UIButton](count: 2, repeatedValue: UIButton())
     
                let x = 0
                
//                for x in 0...1 {
//                    let button = myButtons[x]
//                    var buttonString = ""
//                    var buttonFrame = CGRect(x: 0, y: CGFloat(150 * x), width: self.view.frame.width, height: 100)
//                
//                    switch x {
//                    case 0:
//                        buttonString = "Go To Sleep"
//                    case 1:
//                        buttonString = "See Your Dreams"
//                    default: () }
//                    
//                    let buttonUpString = NSAttributedString(string: buttonString, attributes: Dictionary(dictionaryLiteral: (NSForegroundColorAttributeName, DreamRightSK.color2), (NSFontAttributeName, UIFont(name: "HelveticaNeue-Thin", size: 20)!)))
//                    
//                    let buttonDownString = NSAttributedString(string: buttonString, attributes: Dictionary(dictionaryLiteral: (NSForegroundColorAttributeName, UIColor.whiteColor()), (NSFontAttributeName, UIFont(name: "HelveticaNeue-Thin", size: 20)!)))
//                    
//                    button.frame = buttonFrame
//                    button.alpha = 0.0
//                    button.backgroundColor = UIColor.clearColor()
//                    button.setAttributedTitle(buttonUpString, forState: UIControlState.Normal)
//                    button.setAttributedTitle(buttonDownString, forState: UIControlState.Highlighted)
//                    
//                    self.view.addSubview(button)
//                }
                
                let gravitySleep = UIGravityBehavior(items: [myButtons[0]])
                gravitySleep.magnitude = 1.3
                
                let collisionSleep = UICollisionBehavior(items: [myButtons[0]])
                collisionSleep.translatesReferenceBoundsIntoBoundary = true
                
                let elasticitySleep = UIDynamicItemBehavior(items: [myButtons[0]])
                elasticitySleep.elasticity = 0.4
                
//                self.animator?.addBehavior(gravitySleep)
//                self.animator?.addBehavior(collisionSleep)
//                self.animator?.addBehavior(elasticitySleep)
                
                UIView.animateWithDuration(1.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                    myButtons[0].alpha = 1.0
                    
                    self.goToSleep.alpha = 1.0
                    self.seeYourDreams.alpha = 1.0
                    self.designTheStars.alpha = 1.0
                    
                    }, completion: nil)
                
                delay(2, {
//                    UIView.animateWithDuration(1.2, delay: 0.00, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                        let dreamOrigin = CGPointMake(self.dreamLayer!.frame.origin.x - 50, self.dreamLayer!.frame.origin.y - 50)
//                        let rightOrigin = CGPointMake(self.rightLayer!.frame.origin.x - 50, self.rightLayer!.frame.origin.y - 50)
//                        
//                        let dreamSize = CGSize(width: self.dreamLayer!.frame.width + 100, height: self.dreamLayer!.frame.height + 100)
//                        let rightSize = CGSize(width: self.rightLayer!.frame.width + 100, height: self.rightLayer!.frame.height + 100)
//                        
//                        self.dreamView!.frame = CGRect(origin: dreamOrigin, size: dreamSize)
//                        self.rightView!.frame = CGRect(origin: rightOrigin, size: rightSize)
//                        
//                        }, completion: nil)
                    
                    
                    
                    
                    
//                    let gravityDream = UIGravityBehavior(items: [myButtons[1]])
//                    gravityDream.magnitude = 1.3
//                    gravitySleep.addItem(myButtons[1])
//                    
//                    let collisionDream = UICollisionBehavior(items: [myButtons[1]])
//                    collisionDream.translatesReferenceBoundsIntoBoundary = true
//                    collisionSleep.addItem(myButtons[1])
//                    
//                    let elasticityDream = UIDynamicItemBehavior(items: [myButtons[1]])
//                    elasticityDream.elasticity = 0.4
//                    elasticitySleep.addItem(myButtons[1])
//                    
////                    self.animator?.addBehavior(gravityDream)
////                    self.animator?.addBehavior(collisionDream)
////                    self.animator?.addBehavior(elasticityDream)
//                    
//                    UIView.animateWithDuration(0.8, delay: 0.04, options: UIViewAnimationOptions.CurveEaseIn, animations: {
//                        myButtons[1].alpha = 1.0
//                        }, completion: nil)
                })
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        return
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Animation variable generators
    
    func drawText() {
        // Create attributed strings and define a frame for the Dream Right text
        let dreamString = NSAttributedString(string: "Dream", attributes: Dictionary(dictionaryLiteral: (NSForegroundColorAttributeName, DreamRightSK.color2), (NSFontAttributeName, UIFont(name: "SavoyeLetPlain", size: 80)!)))
        let dreamRect = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 80)
        
        let rightString = NSAttributedString(string: "Right", attributes: Dictionary(dictionaryLiteral: (NSForegroundColorAttributeName, DreamRightSK.color2), (NSFontAttributeName, UIFont(name: "SavoyeLetPlain", size: 80)!)))
        let rightRect = CGRect(x: 0, y: 130, width: self.view.frame.width, height: 80)
        
        dreamView = UIView(frame: dreamRect)
        dreamView!.backgroundColor = DreamRightSK.color
        
        rightView = UIView(frame: rightRect)
        rightView!.backgroundColor = DreamRightSK.color
        
        // Generate a layer containing beziers for drawing the strings
        dreamLayer = createDrawableString(dreamString, dreamRect)
        rightLayer = createDrawableString(rightString, rightRect)
        
        dreamView!.layer.addSublayer(dreamLayer!)
        rightView!.layer.addSublayer(rightLayer!)
        
        // Add the string generation layers to the view
//        self.view.addSubview(dreamView!)
//        self.view.addSubview(rightView!)
        self.view.layer.addSublayer(dreamLayer!)
        self.view.layer.addSublayer(rightLayer!)
        
        // Configure settings for the actually drawing of the pathh
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 1.5
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.fillMode = kCAFillModeForwards
        
        // Add our animations and let them work their magic
        dreamLayer!.addAnimation(pathAnimation, forKey: "strokeEnd")
        rightLayer!.addAnimation(pathAnimation, forKey: "strokeEnd")
    }
    
    func twinkleStars() {
        // Begin the transition for all stars
        for star in self.stars {
            star.transition(true, twinkle: true)  // Request the twinkle when they complete their animation
        }
    }
    
    func blowUpMoon() {
        // The modifiers keep the moon centered on the big star at all sizes
        let size = 13000.0
        let xMod = 0.19069 * size
        let yMod = 0.3254 * size
        
        // Blow up the moon and destroy it when you're done
        UIView.animateWithDuration(1.0, delay: 0.25, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            if let view = self.moonContainer? {
                view.frame = CGRect(x: Double(self.view.frame.width / 2.0) - xMod, y: Double(self.view.frame.height / 2.0) - yMod, width: size, height: size)
            }}, completion: {
                (value: Bool) in
                if value {
                    self.moonContainer?.removeFromSuperview()
                }
        })
    }
    
    func blastOffTimers() {
        // This timer is used to transition between higher resolution images as the moon zooms in
        moonTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("moonTick"), userInfo: nil, repeats: true)
        
        // This timer is used to grow the ZLSinusWaveView on ticks rather than a block so it can still be updated
        // TODO: The decible tick function could be made into a Helper function taking dictionary of object + frames in userInfo
        decibelTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("decibelTick"), userInfo: nil, repeats: true)
    }
    
    func configureMic() {
        // Configure the sinus wave view
        decibelDisplay = ZLSinusWaveView(frame: CGRect(x: self.view.frame.width / 2, y: 100, width: 0, height: 0))
        decibelDisplay?.backgroundColor = self.view.backgroundColor
        decibelDisplay?.color = UIColor.greenColor()
        decibelDisplay?.plotType = EZPlotType.Buffer
        decibelDisplay?.shouldFill = true
        decibelDisplay?.shouldMirror = true
        
        // Configure the microphone
        microphone = EZMicrophone(delegate: self, startsImmediately: true)
        
        // self.view.addSubview(decibelDisplay!)
    }
    
    func generateMoon() {
        // Draw our moon icon in several sizes
        moon128 = DreamRightSK.imageOfIconCanvas(CGRect(x: 0, y: 0, width: 128, height: 128))
        moon1000 = DreamRightSK.imageOfIconCanvas(CGRect(x: 0, y: 0, width: 1000, height: 1000))
        moon1500 = DreamRightSK.imageOfIconCanvas(CGRect(x: 0, y: 0, width: 1500, height: 1500))
        moon3000 = DreamRightSK.imageOfIconCanvas(CGRect(x: 0, y: 0, width: 3000, height: 3000))
        
        // Initialize the UIImageView for our moon icon
        moonContainer = UIImageView(image: moon128!)
        moonContainer?.frame = CGRect(x: self.view.frame.width / 2 - 64, y: self.view.frame.height / 2 - 64, width: 128, height: 128)
        
        self.view.addSubview(moonContainer!)
    }
    
    func generateStars() {
        // Define start + end frames for our pretty little stars
        var startFrames = [CGRect]()
        var endFrames = [CGRect]()
        var frames = [[CGRect]]()
        var delays = [NSTimeInterval]()
        var times = [NSTimeInterval]()
        var options = [UIViewAnimationOptions]()
        
        startFrames.append(CGRect(x: 0.8625 * self.view.frame.width, y: 0.1311619718309859 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.728125 * self.view.frame.width, y: 0.3987676056338028 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.1859375 * self.view.frame.width, y: 0.2975352112676056 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.5125 * self.view.frame.width, y: 0.07042253521126761 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.74375 * self.view.frame.width, y: 0.2588028169014084 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.178125 * self.view.frame.width, y: 0.08362676056338028 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.346875 * self.view.frame.width, y: 0.4058098591549296 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.884375 * self.view.frame.width, y: 0.3116197183098591 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.6796875 * self.view.frame.width, y: 0.1302816901408451 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.315625 * self.view.frame.width, y: 0.02816901408450704 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.0859375 * self.view.frame.width, y: 0.2077464788732394 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.5828125 * self.view.frame.width, y: 0.3855633802816901 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.521875 * self.view.frame.width, y: 0.238556338028169 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.2078125 * self.view.frame.width, y: 0.159330985915493 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.7203125 * self.view.frame.width, y: 0.05897887323943662 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.903125 * self.view.frame.width, y: 0.2315140845070423 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.1828125 * self.view.frame.width, y: 0.3987676056338028 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.890625 * self.view.frame.width, y: 0.3961267605633803 * self.view.frame.height, width: 0, height: 0))
        startFrames.append(CGRect(x: 0.0546875 * self.view.frame.width, y: 0.0625 * self.view.frame.height, width: 0, height: 0))
        
        endFrames.append(CGRect(x: 0.8625 * self.view.frame.width, y: 0.1311619718309859 * self.view.frame.height, width: 47, height: 47))
        endFrames.append(CGRect(x: 0.728125 * self.view.frame.width, y: 0.3987676056338028 * self.view.frame.height, width: 47, height: 47))
        endFrames.append(CGRect(x: 0.1859375 * self.view.frame.width, y: 0.2975352112676056 * self.view.frame.height, width: 47, height: 47))
        endFrames.append(CGRect(x: 0.5125 * self.view.frame.width, y: 0.07042253521126761 * self.view.frame.height, width: 47, height: 47))
        endFrames.append(CGRect(x: 0.74375 * self.view.frame.width, y: 0.2588028169014084 * self.view.frame.height, width: 34, height: 34))
        endFrames.append(CGRect(x: 0.178125 * self.view.frame.width, y: 0.08362676056338028 * self.view.frame.height, width: 32, height: 32))
        endFrames.append(CGRect(x: 0.346875 * self.view.frame.width, y: 0.4058098591549296 * self.view.frame.height, width: 33, height: 33))
        endFrames.append(CGRect(x: 0.884375 * self.view.frame.width, y: 0.3116197183098591 * self.view.frame.height, width: 22, height: 22))
        endFrames.append(CGRect(x: 0.6796875 * self.view.frame.width, y: 0.1302816901408451 * self.view.frame.height, width: 21, height: 21))
        endFrames.append(CGRect(x: 0.315625 * self.view.frame.width, y: 0.02816901408450704 * self.view.frame.height, width: 23, height: 23))
        endFrames.append(CGRect(x: 0.0859375 * self.view.frame.width, y: 0.2077464788732394 * self.view.frame.height, width: 22, height: 22))
        endFrames.append(CGRect(x: 0.5828125 * self.view.frame.width, y: 0.3855633802816901 * self.view.frame.height, width: 21, height: 21))
        endFrames.append(CGRect(x: 0.521875 * self.view.frame.width, y: 0.238556338028169 * self.view.frame.height, width: 9, height: 9))
        endFrames.append(CGRect(x: 0.2078125 * self.view.frame.width, y: 0.159330985915493 * self.view.frame.height, width: 14, height: 14))
        endFrames.append(CGRect(x: 0.7203125 * self.view.frame.width, y: 0.05897887323943662 * self.view.frame.height, width: 8, height: 8))
        endFrames.append(CGRect(x: 0.903125 * self.view.frame.width, y: 0.2315140845070423 * self.view.frame.height, width: 14, height: 14))
        endFrames.append(CGRect(x: 0.1828125 * self.view.frame.width, y: 0.3987676056338028 * self.view.frame.height, width: 11, height: 11))
        endFrames.append(CGRect(x: 0.890625 * self.view.frame.width, y: 0.3961267605633803 * self.view.frame.height, width: 12, height: 12))
        endFrames.append(CGRect(x: 0.0546875 * self.view.frame.width, y: 0.0625 * self.view.frame.height, width: 14, height: 14))
        
        delays.append(0.100000001490116)
        delays.append(0.200000002980232)
        delays.append(0.100000001490116)
        delays.append(0.400000005960464)
        delays.append(0.400000005960464)
        delays.append(0.400000005960464)
        delays.append(0.5)
        delays.append(0.300000011920929)
        delays.append(0.800000011920929)
        delays.append(0.600000023841858)
        delays.append(0.300000011920929)
        delays.append(0.600000023841858)
        delays.append(0.899999976158142)
        delays.append(0.200000002980232)
        delays.append(0.300000011920929)
        delays.append(0.400000005960464)
        delays.append(0.699999988079071)
        delays.append(0.100000001490116)
        delays.append(0.300000011920929)
        
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        times.append(0.800000011920929)
        
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        options.append(UIViewAnimationOptions.CurveEaseIn)
        
        for x in 0...startFrames.count - 1 {
            var curGroup = [CGRect]()
            curGroup.append(startFrames[x])
            curGroup.append(endFrames[x])
            
            frames.append(curGroup)
        }
        
        // Get our star objects
        stars = getStars(frames, delays, times, options)
        
        for star in stars {
            self.view.addSubview(star.view)
        }
    }
    
    // MARK: NSTimer callbacks
    
    // Adjusts the moon icon's resolution
    func moonTick() {
        if moonCounter > 15 {
            moonTimer?.invalidate()
            return
        }
        
        moonCounter++
        
        if moonCounter == 3 {
            moonContainer?.image = moon1000
        }
        else if moonCounter == 7 {
            moonContainer?.image = moon1500
        }
        else if moonCounter == 14 {
            moonContainer?.image = moon3000
        }
    }
    
    // Update the frame of the ZLSinusWaveView
    func decibelTick() {
        let start: CGFloat = 90
        let end: CGFloat = 130
        let total: CGFloat = end - start
        
        if decibelCounter == end {
            decibelTimer?.invalidate()
            microphone?.startFetchingAudio()
            return
        }
        else {
            decibelCounter++
        }
        
        if decibelCounter <= start {
            return
        }
        
        let newX: CGFloat = decibelDisplay!.frame.origin.x - self.view.frame.width / 2 / total
        let newY: CGFloat = decibelDisplay!.frame.origin.y - 75 / total
        let newWidth: CGFloat = decibelDisplay!.frame.width + self.view.frame.width / total
        let newHeight: CGFloat = decibelDisplay!.frame.height + 150 / total
        
        dispatch_async(dispatch_get_main_queue()) {
            if let display = self.decibelDisplay? {
                display.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
            }
        }
    }
    
    // MARK: - Transition Delegates / Animations
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "designSegue" {
            let designVC = segue.destinationViewController as TestViewControllerB
            
            designVC.transitioningDelegate = transitionManager
        }
    }
    
    // MARK: - EZMicrophone Delegate Function
    
    func microphone(microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>>, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        dispatch_async(dispatch_get_main_queue()) {
            // Update the main buffer
            if let display = self.decibelDisplay? {
                display.updateBuffer(buffer[0], withBufferSize: bufferSize)
            }
        }
    }
}