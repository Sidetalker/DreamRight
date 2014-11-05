//
//  TestViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/4/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

struct StarContainer {
    var star: Star
    var view: UIView
}

enum Handles {
    case TopLeftCorner
    case TopRightCorner
    case BottomLeftCorner
    case BottomRightCorner
    case LeftSide
    case RightSide
    case Top
    case Bottom
}

extension String {
    var floatValue: CGFloat {
        return CGFloat((self as NSString).floatValue)
    }
}

class TestViewControllerA: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    
    @IBOutlet var btnRecord: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var btnPlay: UIButton!
    
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
        
        self.view.backgroundColor = UIColor.blackColor()
        
        let starFrames = [CGRect(x: 50, y: 50, width: 10, height: 30), CGRect(x: 100, y: 0, width: 20, height: 30), CGRect(x: 200, y: 0, width: 200, height: 300), CGRect(x: 0, y: 100, width: 10, height: 20)]
        let starViews = getStars(starFrames)
        
        for star in starViews {
            self.view.addSubview(star)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordPressed(sender: AnyObject) {
//        if (player!.playing) {
//            player?.stop()
//        }
        
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
    
    // This takes a list of star frames... the origin of each frame corresponds to the
    // center of the resulting star. The width and height correspond respectively to the min and
    // max possible values of the resulting star
    func getStars(starFrames: [CGRect]) -> [UIImageView] {
        var stars = [UIImageView]()
        
        for star in starFrames {
            let starSizeMax = star.width
            let starSizeMin = star.height
            let origin = star.origin
            
            var newSize = CGFloat(arc4random_uniform(UInt32(starSizeMin)) + UInt32(starSizeMax))
            var newX = origin.x - newSize / 2
            var newY = origin.y - newSize / 2
            
            if newX < 0 {
                newX = 0
            }
            if newY < 0 {
                newY = 0
            }
            if newX > self.view.frame.width {
                newX = self.view.frame.width - newSize
            }
            if newY > self.view.frame.height {
                newY = self.view.frame.height - newSize
            }
            
            let imageContainer = UIImageView(frame: CGRect(x: newX, y: newY, width: CGFloat(newSize), height: CGFloat(newSize)))
            imageContainer.image = DreamRightSK.imageOfLoneStar(CGRect(x: 0, y: 0, width: CGFloat(newSize), height: CGFloat(newSize)))
            
            stars.append(imageContainer)
            
            NSLog("Starting container: \(star)\nEnding container: \(imageContainer.frame)")
        }
        
        return stars
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
        
        mainLongPress = UILongPressGestureRecognizer(target: self, action: Selector("mainLongPress:"))
        mainLongPress?.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(mainLongPress!)
        
        mainDoubleTap = UITapGestureRecognizer(target: self, action: Selector("mainDoubleTap:"))
        mainDoubleTap?.numberOfTapsRequired = 3
        self.view.addGestureRecognizer(mainDoubleTap!)
        
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
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().height
        
        self.bottomGuideA.constant += keyboardHeight
        self.bottomGuideB.constant += keyboardHeight
        self.bottomGuideC.constant += keyboardHeight
        
        UIView.animateWithDuration(0.9, animations: {
            for container in self.starContainers {
                container.view.alpha = 0.0
            }
            
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().height
        
        self.bottomGuideA.constant -= keyboardHeight
        self.bottomGuideB.constant -= keyboardHeight
        self.bottomGuideC.constant -= keyboardHeight
        
        UIView.animateWithDuration(0.9, animations: {
            for container in self.starContainers {
                container.view.alpha = 1.0
            }
            
            self.view.layoutIfNeeded()
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func startTouchUp(sender: AnyObject) {
        for container in starContainers {
            let star = container.star
            let view = container.view
            let startWidth = view.layer.borderWidth
            
            view.layer.borderWidth = 0.0
            
            if forwardOrBack {
                UIView.animateWithDuration(star.time, delay: star.delay, options: star.animationOptions, animations: {
                    let finalSize = star.finalFrame.size
                    let fixedFrame = CGRect(x: view.frame.width / 2 - finalSize.width / 2, y: view.frame.height / 2 - finalSize.height / 2, width: finalSize.width, height: finalSize.height)
                    
                    star.view.frame = fixedFrame
                    }, completion: {
                        (value: Bool) in
                        if (value) {
                            view.layer.borderWidth = startWidth
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
                            view.layer.borderWidth = startWidth
                        }
                })
            }
        }
        
        forwardOrBack = !forwardOrBack
    }
    
    @IBAction func rebuildTouchUp(sender: AnyObject) {
        
    }
    
    func mainTap(gesture: UITapGestureRecognizer) {
        NSLog("Main Tap")
        
        self.view.endEditing(true)
        
        if starContainers.isEmpty {
            return
        }
        
        for container in starContainers {
            if container.view.layer.borderWidth == 0 {
                container.view.layer.borderWidth == 0.5
                activeContainer = -1
            }
        }
    }
    
    func mainDoubleTap(gesture: UITapGestureRecognizer) {
        NSLog("Main Triple Tap")
        
        for container in starContainers {
            container.view.removeFromSuperview()
        }
        
        activeContainer = -1
        starContainers = [StarContainer]()
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
        
        let newStar = getStars([[starStartFrame, starEndFrame]], animationDelays: animationDelay, animationLengths: animationLength, animationOptions: animationOptions)[0]
        newStar.view.backgroundColor = UIColor.clearColor()
        
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
        
        newView.addSubview(newStar.view)
        self.view.addSubview(newView)
        
        if starContainers.count > 0 {
            for x in 0...starContainers.count - 1 {
                starContainers[x].view.layer.borderWidth = 0.5
            }
        }
        
        let newSize = newStar.view.frame.width
        
        starContainers.append(StarContainer(star: newStar, view: newView))
        newStar.view.frame = CGRect(x: newView.frame.width / 2, y: newView.frame.height / 2, width: 0, height: 0)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            let starViewFrame = CGRect(x: viewEndFrame.width / 2 - newSize / 2, y: viewEndFrame.height / 2 - newSize / 2, width: newSize, height: newSize)

            newView.frame = viewEndFrame
            newStar.view.frame = starViewFrame
            
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
        
        for x in 0...starContainers.count - 1 {
            starContainers[x].view.layer.borderWidth = 0.5
            
            if recognizer.view == starContainers[x].view {
                activeContainer = x
                txtAnimationLength.text = "\(starContainers[x].star.time)"
                txtDelay.text = "\(starContainers[x].star.delay)"
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
        
        if starContainers.isEmpty {
            return
        }
        
        var currentStar = starContainers[activeContainer].star
        
        currentStar.time = NSTimeInterval(txtAnimationLength.text.toInt()!)
        currentStar.delay = NSTimeInterval(txtDelay.text.toInt()!)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    
    func getStars(starFrames: [[CGRect]], animationDelays: [NSTimeInterval], animationLengths: [NSTimeInterval], animationOptions: [UIViewAnimationOptions]) -> [Star] {
        var stars = [Star]()
        
        for x in 0...starFrames.count - 1 {
            let startFrame = starFrames[x][0]
            let endFrame = starFrames[x][1]
            
            let starSizeMinA = Int(startFrame.width)
            let starSizeMaxA = Int(startFrame.height)
            let starSizeMinB = Int(endFrame.width)
            let starSizeMaxB = Int(endFrame.height)
            let originA = startFrame.origin
            let originB = endFrame.origin
            
            var newStartSizeA = starSizeMinA
            var newStartSizeB = starSizeMinB
            
            if starSizeMinA != starSizeMaxA {
                newStartSizeA = Int(arc4random_uniform(UInt32(starSizeMaxA - starSizeMinA))) + starSizeMinA
            }
            if starSizeMinB != starSizeMaxB {
                newStartSizeB = Int(arc4random_uniform(UInt32(starSizeMaxB - starSizeMinB))) + starSizeMinB
            }
            
            var newXA = originA.x
            var newYA = originA.y
            var newXB = originB.x
            var newYB = originB.y
            
            if newStartSizeA > 0 {
                newXA -= CGFloat(newStartSizeA / 2)
                newYA -= CGFloat(newStartSizeA / 2)
            }
            
            if newStartSizeB > 0 {
                newXB -= CGFloat(newStartSizeB / 2)
                newYB -= CGFloat(newStartSizeB / 2)
            }
            
            let newStartFrame = CGRect(x: newXA, y: newYA, width: CGFloat(newStartSizeA), height: CGFloat(newStartSizeA))
            let newEndFrame = CGRect(x: newXB, y: newYB, width: CGFloat(newStartSizeB), height: CGFloat(newStartSizeB))
            
            let imageContainer = UIImageView(frame: newStartFrame)
            
            var baseImage: UIImage?
            var finalImage: UIImage?
            
            if newStartSizeA > 0 {
                baseImage = DreamRightSK.imageOfLoneStar(CGRect(x: 0, y: 0, width: CGFloat(newStartSizeA), height: CGFloat(newStartSizeA)))
            }
            if newStartSizeB > 0 {
                finalImage = DreamRightSK.imageOfLoneStar(CGRect(x: 0, y: 0, width: CGFloat(newStartSizeB), height: CGFloat(newStartSizeB)))
            }
            
            if newStartSizeA > newStartSizeB {
                imageContainer.image = baseImage
            }
            else {
                imageContainer.image = finalImage
            }
            
            stars.append(Star(view: imageContainer, baseImage: baseImage, finalImage: finalImage, delay: animationDelays[x], time: animationLengths[x], animationOptions: animationOptions[x], baseFrame: newStartFrame, finalFrame: newEndFrame))
        }
        
        return stars
    }
}