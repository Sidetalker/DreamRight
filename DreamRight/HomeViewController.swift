//
//  HomeViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 10/31/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

struct Star {
    var view: UIImageView?
    var baseFrame: CGRect
    var finalFrame: CGRect
}

class HomeViewController: UIViewController, EZMicrophoneDelegate {
    
    // MARK: - IBOutlets
    
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
    
    // MARK: - Start animation variables
    var stars: Array<UIImageView>?
    
    // MARK: - UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define start + end frames for our pretty little stars
        
        
        // Draw our moon icon in several sizes
        moon128 = DreamRightSK.imageOfIconCanvas(CGRect(x: 0, y: 0, width: 128, height: 128))
        moon1000 = DreamRightSK.imageOfIconCanvas(CGRect(x: 0, y: 0, width: 1000, height: 1000))
        moon1500 = DreamRightSK.imageOfIconCanvas(CGRect(x: 0, y: 0, width: 1500, height: 1500))
        moon3000 = DreamRightSK.imageOfIconCanvas(CGRect(x: 0, y: 0, width: 3000, height: 3000))
        
        // Initialize the UIImageView for our moon icon
        moonContainer = UIImageView(image: moon128!)
        moonContainer?.frame = CGRect(x: self.view.frame.width / 2 - 64, y: self.view.frame.height / 2 - 64, width: 128, height: 128)
        
        // Configure the sinus wave view
        decibelDisplay = ZLSinusWaveView(frame: CGRect(x: self.view.frame.width / 2, y: 100, width: 0, height: 0))
        decibelDisplay?.backgroundColor = self.view.backgroundColor
        decibelDisplay?.color = UIColor.greenColor()
        decibelDisplay?.plotType = EZPlotType.Buffer
        decibelDisplay?.shouldFill = true
        decibelDisplay?.shouldMirror = true
        
        // Configure the microphone
        microphone = EZMicrophone(delegate: self, startsImmediately: true)
        
        // Add everything to the view
        self.view.addSubview(moonContainer!)
        self.view.addSubview(decibelDisplay!)
    }
    
    // Start our animation once the view has been presented
    override func viewDidAppear(animated: Bool) {
        // This timer is used to transition between higher resolution images as the moon zooms in
        moonTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("moonTick"), userInfo: nil, repeats: true)
        
        // This timer is used to grow the ZLSinusWaveView on ticks rather than a block so it can still be updated
        // TODO: The decible tick function could be made into a Helper function taking dictionary of object + frames in userInfo
        decibelTimer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("decibelTick"), userInfo: nil, repeats: true)

        // The modifiers keep the moon centered on the big star at all sizes
        let size = 13000.0
        let xMod = 0.19069 * size
        let yMod = 0.3254 * size
        
        UIView.animateWithDuration(1.0, delay: 0.25, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            if let view = self.moonContainer? {
                view.frame = CGRect(x: Double(self.view.frame.width / 2.0) - xMod, y: Double(self.view.frame.height / 2.0) - yMod, width: size, height: size)
            }}, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        return
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
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
    
    // MARK: - Helpers
    
    // This takes a list of star frames... the origin of each frame corresponds to the
    // center of the resulting star. The width and height correspond respectively to the min and
    // max possible values of the resulting star. An array of star objects is returned
    func getStars(starFrames: [[CGRect]]) -> [Star] {
        var stars = [Star]()
        
        for star in starFrames {
            let startFrame = star[0]
            let endFrame = star[1]
            
            let starSizeMax = startFrame.width
            let starSizeMin = startFrame.height
            let origin = startFrame.origin
            
            var newSize = CGFloat(arc4random_uniform(UInt32(starSizeMin)) + UInt32(starSizeMax))
            var newX = origin.x
            var newY = origin.y
            
            if newSize > 0 {
                newX -= newSize / 2
                newY -= newSize / 2
            }
            
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
            
            stars.append(Star(view: imageContainer, baseFrame: startFrame, finalFrame: endFrame))
        }
        
        return stars
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