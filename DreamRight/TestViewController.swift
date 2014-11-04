//
//  TestViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/4/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

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
