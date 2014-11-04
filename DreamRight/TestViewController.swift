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
}
