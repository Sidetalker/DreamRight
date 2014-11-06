//
//  TestViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/4/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

class TestViewControllerA: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    
    @IBOutlet var btnRecord: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var btnPlay: UIButton!
    
    var textLayer: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let outputPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String
        let outputURL = NSURL(fileURLWithPath: outputPath.stringByAppendingPathComponent("myMemo.m4a"))
        
        let session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        var recordSettings: [NSObject : AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2
        
        recorder = AVAudioRecorder(URL: outputURL!, settings: recordSettings, error: nil)
        recorder?.delegate = self
        recorder?.meteringEnabled = true
        
        recorder?.prepareToRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordPressed(sender: AnyObject) {
        if (!recorder!.recording) {
            let session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            
            recorder?.record()
            btnRecord.setTitle("Pause", forState: UIControlState.Normal)
        }
        else {
            recorder?.pause()
            btnRecord.setTitle("Record", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        recorder?.stop()
        
        let session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }

    @IBAction func playPressed(sender: AnyObject) {
        if (player == nil) {
            var er: NSError?
            player = AVAudioPlayer(contentsOfURL: recorder!.url, error: &er)
            
            if (er != nil) {
                print("Error: \(er.debugDescription)")
                print("Recorder URL: \(recorder!.url)")
            }
            
            player?.delegate = self
        }
        
        if (!recorder!.recording) {
            player?.play()
        }
    }
}

class TestViewControllerB: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet var lblMinA: UILabel!
    @IBOutlet var lblMaxA: UILabel!
    @IBOutlet var lblMinB: UILabel!
    @IBOutlet var lblMaxB: UILabel!
    
    @IBOutlet var txtMinA: UITextField!
    @IBOutlet var txtMaxA: UITextField!
    @IBOutlet var txtMinB: UITextField!
    @IBOutlet var txtMaxB: UITextField!
    @IBOutlet var txtDelay: UITextField!
    @IBOutlet var txtAnimationLength: UITextField!
    
    @IBOutlet var bottomGuideA: NSLayoutConstraint!
    @IBOutlet var bottomGuideB: NSLayoutConstraint!
    @IBOutlet var bottomGuideC: NSLayoutConstraint!

    // MARK: - Star animation variables
    var stars = [Star]()
    var starRequests = [UIView]()
    var starTimer: NSTimer?
    var starCounter: CGFloat = 0
    
    // MARK: - Dynamic star declaration objects
    var starContainers = [StarContainer]()
    
    // MARK: - Gesture recognizers
    var mainLongPress: UILongPressGestureRecognizer?
    var mainTap: UITapGestureRecognizer?
    var mainDoubleTap: UITapGestureRecognizer?
    var mainTripleTap: UITapGestureRecognizer?
    var subTap: UITapGestureRecognizer?
    var subDoubleTap: UITapGestureRecognizer?
    var subPan: UIPanGestureRecognizer?
    
    // MARK: - State variables
    var activeContainer = -1
    var panBaseLoc: CGPoint?
    var panBaseSize: CGSize?
    var panOrSize = true
    var forwardOrBack = true
    var sizeHandle: Handles?
    var keyboardUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Working for a single star - just testing the function
//        // Define start + end frames for our pretty little stars
//        var startFrames = [CGRect]()
//        var endFrames = [CGRect]()
//        var frames = [[CGRect]]()
//        var delays = [NSTimeInterval]()
//        var times = [NSTimeInterval]()
//        var options = [UIViewAnimationOptions]()
//        
//        startFrames.append(CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 0, height: 0))
//        endFrames.append(CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 25, height: 25))
//        delays.append(0)
//        times.append(1.5)
//        options.append(UIViewAnimationOptions.CurveEaseIn)
//        
//        for x in 0...startFrames.count - 1 {
//            var curGroup = [CGRect]()
//            curGroup.append(startFrames[x])
//            curGroup.append(endFrames[x])
//            
//            frames.append(curGroup)
//        }
//        
//        // Get our star objects
//        stars = getStars(frames, animationDelays: delays, animationLengths: times, animationOptions: options)
//        
//        for star in stars {
//            self.view.addSubview(star.view)
//            star.transition(true)
        //        }
        
        let dreamString = NSAttributedString(string: "Dream", attributes: Dictionary(dictionaryLiteral: (NSForegroundColorAttributeName, DreamRightSK.color2), (NSFontAttributeName, UIFont(name: "SavoyeLetPlain", size: 80)!)))
        let dreamRect = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 80)
        
        let rightString = NSAttributedString(string: "Right", attributes: Dictionary(dictionaryLiteral: (NSForegroundColorAttributeName, DreamRightSK.color2), (NSFontAttributeName, UIFont(name: "SavoyeLetPlain", size: 80)!)))
        let rightRect = CGRect(x: 0, y: 130, width: self.view.frame.width, height: 80)
        
        let dreamLayer = createDrawableString(dreamString, dreamRect)
        let rightLayer = createDrawableString(rightString, rightRect)
        
        self.view.layer.addSublayer(dreamLayer)
        self.view.layer.addSublayer(rightLayer)
        
        let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 2.5
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation.fillMode = kCAFillModeForwards
        
        dreamLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
        rightLayer.addAnimation(pathAnimation, forKey: "strokeEnd")
        
        mainLongPress = UILongPressGestureRecognizer(target: self, action: Selector("mainLongPress:"))
        mainLongPress?.minimumPressDuration = 0.44
        self.view.addGestureRecognizer(mainLongPress!)
        
        mainDoubleTap = UITapGestureRecognizer(target: self, action: Selector("mainDoubleTap:"))
        mainDoubleTap?.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(mainDoubleTap!)
        
        mainTripleTap = UITapGestureRecognizer(target: self, action: Selector("mainTripleTap:"))
        mainTripleTap?.numberOfTapsRequired = 3
        self.view.addGestureRecognizer(mainTripleTap!)
        
        mainTap = UITapGestureRecognizer(target: self, action: Selector("mainTap:"))
        self.view.addGestureRecognizer(mainTap!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        for view in self.view.subviews {
            if let textField = view as? UITextField {
                textField.delegate = self
            }
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        NSLog("keyboardWillShow")
        
        keyboardUp = true
        
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().height
        
        self.bottomGuideA.constant += keyboardHeight
        self.bottomGuideB.constant += keyboardHeight
        self.bottomGuideC.constant += keyboardHeight
        
        UIView.animateWithDuration(0.9, animations: {
            if !self.starContainers.isEmpty {
                for container in self.starContainers {
                    container.view.alpha = 0.0
                }
            }
            
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        NSLog("keyboardWillHide")
        
        keyboardUp = false
        
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().height
        
        self.bottomGuideA.constant -= keyboardHeight
        self.bottomGuideB.constant -= keyboardHeight
        self.bottomGuideC.constant -= keyboardHeight
        
        if self.starContainers.isEmpty {
            return
        }
        
        UIView.animateWithDuration(0.9, animations: {
            for container in self.starContainers {
                    container.view.alpha = 1.0
                }
            
            self.view.layoutIfNeeded()
        })
        
        if activeContainer == -1 {
            return
        }
        
        starContainers[activeContainer].star.time = NSTimeInterval(txtAnimationLength.text.floatValue)
        starContainers[activeContainer].star.delay = NSTimeInterval(txtDelay.text.floatValue)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func startTouchUp(sender: AnyObject) {
        for container in starContainers {
            let star = container.star
            let view = container.view
            let startWidth = view.layer.borderWidth
            
//            view.layer.borderWidth = 0.0
            
            if forwardOrBack {
                UIView.animateWithDuration(star.time, delay: star.delay, options: star.animationOptions, animations: {
                    let finalSize = star.finalFrame.size
                    let fixedFrame = CGRect(x: view.frame.width / 2 - finalSize.width / 2, y: view.frame.height / 2 - finalSize.height / 2, width: finalSize.width, height: finalSize.height)
                    
                    star.view.frame = fixedFrame
                    }, completion: {
                        (value: Bool) in
                        if (value) {
//                            view.layer.borderWidth = startWidth
                        }
                })
            }
            else {
                UIView.animateWithDuration(star.time, delay: star.delay, options: star.animationOptions, animations: {
                    let finalSize = star.baseFrame.size
                    let fixedFrame = CGRect(x: view.frame.width / 2 - finalSize.width / 2, y: view.frame.height / 2 - finalSize.height / 2, width: finalSize.width, height: finalSize.height)
                    
                    star.view.frame = fixedFrame
                    }, completion: {
                        (value: Bool) in
                        if (value) {
//                            view.layer.borderWidth = startWidth
                        }
                })
            }
        }
        
        forwardOrBack = !forwardOrBack
    }
    
    @IBAction func rebuildTouchUp(sender: AnyObject) {
        print("Our strings:\n\n\(dataDictToStrings(getDataDict()))")
    }
    
    func getDataDict() -> [[NSObject : AnyObject]] {
        var allData = [[NSObject : AnyObject]]()
        
        for container in starContainers {
            var curStar = container.star
            var curFrame = container.view.frame
            var curDict = [NSObject : AnyObject]()
            
            // STAR ORIGIN IS CENTER REFERENCED - USE THE CENTER OF THE UIIMAGEVIEW
            curDict["baseFrame"] = [(curFrame.origin.x + curFrame.width / 2) / self.view.frame.width, (curFrame.origin.y + curFrame.height / 2) / self.view.frame.height, curStar.baseFrame.width, curStar.baseFrame.width]
            curDict["finalFrame"] = [(curFrame.origin.x + curFrame.width / 2) / self.view.frame.width, (curFrame.origin.y + curFrame.height / 2) / self.view.frame.height, curStar.finalFrame.width, curStar.finalFrame.width]
            curDict["delay"] = curStar.delay
            curDict["time"] = curStar.time
            curDict["animationOptions"] = curStar.animationOptions.rawValue
            
            allData.append(curDict)
        }
        
        return allData
    }
    
    func dataDictToStrings(data: [[NSObject : AnyObject]]) -> String {
        var finalString = ""
        var startFrames = ""
        var endFrames = ""
        var delays = ""
        var times = ""
        var options = ""
        
        for dict in data {
            if let containerFrame = dict["baseFrame"] as? NSArray {
                startFrames += "startFrames.append(CGRect(x: \(containerFrame[0] as NSNumber) * self.view.frame.width), y: \(containerFrame[1] as NSNumber) * self.view.frame.height), width: \(containerFrame[2]), height: \(containerFrame[3])))\n"
            }
            
            if let containerFrame = dict["finalFrame"] as? NSArray {
                endFrames += "endFrames.append(CGRect(x: \(containerFrame[0] as NSNumber) * self.view.frame.width), y: \(containerFrame[1] as NSNumber) * self.view.frame.height), width: \(containerFrame[2]), height: \(containerFrame[3])))\n"
            }
            
            if let delay = dict["delay"] as? NSTimeInterval {
                delays += "delays.append(\(delay))\n"
            }
            
            if let time = dict["time"] as? NSTimeInterval {
                times += "times.append(\(time))\n"
            }
            
            if let option = dict["options"] as? UInt {
                options += "options.append(UIViewAnimationOptions.CurveEaseIn)\n"
            }
        }
        
        finalString += startFrames + "\n"
        finalString += endFrames + "\n"
        finalString += delays + "\n"
        finalString += times + "\n"
        finalString += options + "\n"
        
        return finalString
    }
    
    func mainTripleTap(gesture: UITapGestureRecognizer) {
        NSLog("Main Triple Tap")
        
        for container in starContainers {
            container.view.removeFromSuperview()
        }
        
        forwardOrBack = true
        activeContainer = -1
        starContainers = [StarContainer]()
    }
    
    func mainTap(gesture: UITapGestureRecognizer) {
        NSLog("Main Tap")
        
        self.view.endEditing(true)
        
        if starContainers.isEmpty {
            return
        }
        
        let startBorder = starContainers[0].view.layer.borderWidth
        
        for container in starContainers {
            if startBorder != 0 {
                container.view.layer.borderWidth = 0.0
            }
            else {
                container.view.layer.borderWidth = 0.5
            }
        }
        
        activeContainer = -1
    }
    
    func mainDoubleTap(gesture: UITapGestureRecognizer) {
        NSLog("Main Double Tap")
        
        if starContainers.isEmpty {
            return
        }
        
        let startWidth = starContainers[0].view.layer.borderWidth
        
        for container in starContainers {
            if startWidth != 0 {
                container.view.layer.borderWidth = 0
            }
            else {
                container.view.layer.borderWidth = 0.5
            }
        }
        
        activeContainer = -1
    }
    
    func mainLongPress(gesture: UILongPressGestureRecognizer) {
        NSLog("Main Long Press")
        
        if gesture.state == UIGestureRecognizerState.Changed || gesture.state == UIGestureRecognizerState.Ended {
            return
        }
        
        let loc = gesture.locationInView(self.view)
        
        let maxA: CGFloat = txtMaxA.text.floatValue * 10
        let maxB: CGFloat = txtMaxB.text.floatValue * 10
        let frameMax: CGFloat = max(maxA, maxB)
        
        let minA = txtMinA.text.floatValue * 10
        let minB = txtMinB.text.floatValue * 10
        
        let delay = NSTimeInterval(txtDelay.text.floatValue)
        let length = NSTimeInterval(txtAnimationLength.text.floatValue)
        
        let viewStartFrame = CGRect(x: loc.x, y: loc.y, width: 0, height: 0)
        let viewEndFrame = CGRect(x: loc.x - (frameMax / 2), y: loc.y - (frameMax / 2), width: frameMax, height: frameMax)
        
        let starStartFrame = CGRect(x: 0.0, y: 0.0, width: minA, height: maxA)
        let starEndFrame = CGRect(x: 0.0, y: 0.0, width: minB, height: maxB)
        let animationDelay = [delay]
        let animationLength = [length]
        let animationOptions = [UIViewAnimationOptions.CurveEaseOut]
        
        let starRequest = getStars([[starStartFrame, starEndFrame]], animationDelay, animationLength, animationOptions)
        
        if starRequest.count == 0 {
            return
        }
        
        let star = starRequest[0]
        
        star.view.backgroundColor = UIColor.clearColor()
        
        let newView = UIView(frame: viewStartFrame)
        newView.layer.borderColor = DreamRightSK.color2.CGColor
        newView.layer.borderWidth = 2.5
        
        subPan = UIPanGestureRecognizer(target: self, action: Selector("panSubview:"))
        newView.addGestureRecognizer(subPan!)
        
        subTap = UITapGestureRecognizer(target: self, action: Selector("tapSubview:"))
        newView.addGestureRecognizer(subTap!)
        
        subDoubleTap = UITapGestureRecognizer(target: self, action: Selector("doubleTapSubview:"))
        subDoubleTap?.numberOfTapsRequired = 2
        newView.addGestureRecognizer(subDoubleTap!)
        
        newView.addSubview(star.view)
        self.view.addSubview(newView)
        
        if starContainers.count > 0 {
            for x in 0...starContainers.count - 1 {
                starContainers[x].view.layer.borderWidth = 0.5
            }
        }
        
        let newSize = star.view.frame.width
        
        starContainers.append(StarContainer(star: star, view: newView))
        star.view.frame = CGRect(x: newView.frame.width / 2, y: newView.frame.height / 2, width: 0, height: 0)
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            let starViewFrame = CGRect(x: viewEndFrame.width / 2 - newSize / 2, y: viewEndFrame.height / 2 - newSize / 2, width: newSize, height: newSize)

            newView.frame = viewEndFrame
            star.view.frame = starViewFrame
            
            NSLog("UIView Frame: \(viewEndFrame)\nStarView Frame: \(starViewFrame)")
            }, completion: {
                (value: Bool) in
                
        })
    }
    
    func panSubview(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Began {
            if let view = recognizer.view? {
                panBaseLoc = recognizer.locationInView(view)
                panBaseSize = view.frame.size
                
                for container in starContainers {
                    container.view.layer.borderWidth = 0.5
                }
                
                view.layer.borderWidth = 2.5
                
                let width = view.frame.width
                let height = view.frame.height
                let tuplePoint = (panBaseLoc!.x, panBaseLoc!.y)
                
                panOrSize = false
                
                switch tuplePoint {
                case (0...10, 0...10): // Top left corner
                    sizeHandle = Handles.TopLeftCorner
                case (0...10, height - 10...height): // Bottom left corner
                    sizeHandle = Handles.BottomLeftCorner
                case (width - 10...width, 0...10): // Top right corner
                    sizeHandle = Handles.TopRightCorner
                case (width - 10...width, height - 10...height): // Bottom right corner
                    sizeHandle = Handles.BottomRightCorner
                case (0...10, _): // Left side
                    sizeHandle = Handles.LeftSide
                case (width - 10...width, _): // Right side
                    sizeHandle = Handles.RightSide
                case (_, 0...10): // Top
                    sizeHandle = Handles.Top
                case (_, height - 10...height): // Bottom
                    sizeHandle = Handles.Bottom
                default:
                    panOrSize = true
                }
                
                panOrSize = true // Disable panning
            }
        }
        
        if let view = recognizer.view? {
            let baseLoc = recognizer.locationInView(self.view)
            let localLoc = recognizer.locationInView(view)
            
            let newCenterX = baseLoc.x - panBaseLoc!.x
            let newCenterY = baseLoc.y - panBaseLoc!.y
            
            if panOrSize {
                view.frame = CGRect(x: newCenterX, y: newCenterY, width: view.frame.width, height: view.frame.height)
            }
        }
    }
    
    func tapSubview(recognizer: UITapGestureRecognizer) {
        NSLog("Subview Tap")
        
        if activeContainer >= 0 {
            starContainers[activeContainer].star.time = NSTimeInterval(txtAnimationLength.text.floatValue)
            starContainers[activeContainer].star.delay = NSTimeInterval(txtDelay.text.floatValue)
        }
        
        for x in 0...starContainers.count - 1 {
            starContainers[x].view.layer.borderWidth = 0.5
            
            if recognizer.view == starContainers[x].view {
                activeContainer = x
                txtAnimationLength.text = NSString(format: "%.0001f", starContainers[x].star.time)
                txtDelay.text = NSString(format: "%.0001f", starContainers[x].star.delay)
            }
        }
        recognizer.view!.layer.borderWidth = 2.5
        self.view.bringSubviewToFront(recognizer.view!)
    }
    
    func doubleTapSubview(recognizer: UITapGestureRecognizer) {
        NSLog("Subview Double Tap")
        
        for x in 0...starContainers.count - 1 {
            if recognizer.view == starContainers[x].view {
                starContainers[x].view.removeFromSuperview()
                starContainers.removeAtIndex(x)
                activeContainer = -1
                return
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = "0"
        }
        
        if activeContainer == -1 {
            return
        }
        
        starContainers[activeContainer].star.time = NSTimeInterval(txtAnimationLength.text.floatValue)
        starContainers[activeContainer].star.delay = NSTimeInterval(txtDelay.text.floatValue)
    }
}