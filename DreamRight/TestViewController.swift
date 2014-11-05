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

class TestViewControllerB: UIViewController {
    
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
    
    // MARK: - Star animation variables
    var stars = [Star]()
    var starRequests = [UIView]()
    var starTimer: NSTimer?
    var starCounter: CGFloat = 0
    
    // MARK: - Dynamic star declaration objects
    var starContainers = [StarContainer]()
    
    
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
        
        let createReceiver = UILongPressGestureRecognizer(target: self, action: Selector("mainLongPress"))
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func startTouchUp(sender: AnyObject) {
        
    }
    
    func mainLongPress(recognizer: UILongPressGestureRecognizer) {
        let loc = recognizer.locationInView(self.view)
        
        let maxA = CGFloat(txtMaxA.text.toInt()!)
        let maxB = CGFloat(txtMaxB.text.toInt()!)
        let frameMax: CGFloat = max(maxA, maxB)
        
        let minA = txtMinA.text.toInt()
        let minB = txtMinB.text.toInt()
        
        let viewStartFrame = CGRect(x: loc.x, y: loc.y, width: 0, height: 0)
        let viewEndFrame = CGRect(x: loc.x - (frameMax / 2), y: loc.y - (frameMax / 2), width: frameMax, height: frameMax)
        let animationDelay = [0.0]
        let animationLength = [1.0]
        let animationOptions = UIViewAnimationOptions.CurveEaseOut
        
        
        let newView = UIView(frame: viewStartFrame)
        
        
        
        newView.layer.borderColor = DreamRightSK.color2.CGColor
        newView.layer.borderWidth = 2.0
        
        let cur
        
        
        
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            print("asd")
            }, completion: {
                (value: Bool) in
                if value {
                    print("asda")
                }
        })
    }
    
    func gotTap() {
        
    }
    
    func getStars(starFrames: [[CGRect]], animationDelays: [NSTimeInterval], animationLengths: [NSTimeInterval], animationOptions: [UIViewAnimationOptions]) -> [Star] {
        var stars = [Star]()
        
        for x in 0...starFrames.count - 1 {
            let startFrame = starFrames[x][0]
            let endFrame = starFrames[x][1]
            
            let starSizeMaxA = startFrame.width
            let starSizeMinA = startFrame.height
            let starSizeMaxB = endFrame.width
            let starSizeMinB = endFrame.height
            let originA = startFrame.origin
            let originB = endFrame.origin
            
            var newStartSizeA = CGFloat(arc4random_uniform(UInt32(starSizeMinA)) + UInt32(starSizeMaxA))
            var newStartSizeB = CGFloat(arc4random_uniform(UInt32(starSizeMinB)) + UInt32(starSizeMaxB))
            var newXA = originA.x
            var newYA = originA.y
            var newXB = originB.x
            var newYB = originB.y
            
            if newStartSizeA > 0 {
                newXA -= newStartSizeA / 2
                newYA -= newStartSizeA / 2
            }
            
            if newStartSizeB > 0 {
                newXB -= newStartSizeB / 2
                newYB -= newStartSizeB / 2
            }
            
            let newStartFrame = CGRect(x: newXA, y: newYA, width: newStartSizeA, height: newStartSizeA)
            let newEndFrame = CGRect(x: newXB, y: newYB, width: newStartSizeB, height: newStartSizeB)
            
            let imageContainer = UIImageView(frame: newStartFrame)
            
            if newStartSizeA > newStartSizeB {
                imageContainer.image = DreamRightSK.imageOfLoneStar(CGRect(x: 0, y: 0, width: CGFloat(newStartSizeA), height: CGFloat(newStartSizeA)))
            }
            else {
                imageContainer.image = DreamRightSK.imageOfLoneStar(CGRect(x: 0, y: 0, width: CGFloat(newStartSizeB), height: CGFloat(newStartSizeB)))
            }
            
            stars.append(Star(view: imageContainer, delay: animationDelays[x], time: animationLengths[x], animationOptions: animationOptions[x], baseFrame: newStartFrame, finalFrame: newEndFrame))
        }
        
        return stars
    }
}
