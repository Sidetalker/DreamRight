//
//  DreamViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/8/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

// MARK: - Contants

// Max and min # of stars involved in the burst
let minStars = 9
let maxStars = 11

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

// Time to grow, bring alpha to one and initial start scale
let growthTime = 1.1
let fadeTime = 0.5
let startScale: CGFloat = 1.0
let endScale: CGFloat = 0.01

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
    }
    
    func addImage(image: UIImage, center: CGPoint) {
        let imageView = UIImageView(image: image)
        let size = imageView.frame.width
        let location = CGPoint(x: center.x - size / 2, y: center.y - size / 2)
        
        self.addSubview(imageView)
        self.stars.append(imageView)
        
        imageView.frame = CGRect(origin: location, size: CGSize(width: size, height: size))
        imageView.alpha = 0.0
//        imageView.layer.transform = CATransform3DMakeScale(startScale, startScale, 1.0)
        animator = UIDynamicAnimator(referenceView: self)
        
        self.animator.addBehavior(gravity)
        self.animator.addBehavior(velocityAndShit)
    }
    
    func explode() {
        for star in stars {
            let starLocation = star.frame.origin
            
            let curDelay = Double(randomFloatBetweenNumbers(minAnimationDelay, maxAnimationDelay))
            var curAngularity = randomFloatBetweenNumbers(minAngularVelocity, maxAngularVelocity)
            let curHeight = -randomFloatBetweenNumbers(minHeight, maxHeight)
            var curLinearity = CGPoint(x: randomFloatBetweenNumbers(minDirection, maxDirection), y: curHeight)
            
            if randomIntBetweenNumbers(0, 10) % 2 == 1 {
                curAngularity = -curAngularity
            }
            
            if randomIntBetweenNumbers(0, 10) % 2 == 1 {
                curLinearity = CGPoint(x: -curLinearity.x, y: curHeight)
            }
            
            delay(curDelay, {
                self.gravity.addItem(star)
                self.velocityAndShit.addItem(star)
                self.velocityAndShit.addAngularVelocity(curAngularity, forItem: star)
                self.velocityAndShit.addLinearVelocity(curLinearity, forItem: star)
                
                star.transform = CGAffineTransformIdentity
                
                UIView.animateWithDuration(growthTime, delay: 0.0, options: nil, animations: {
//                    star.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5)
                    star.transform = CGAffineTransformMakeScale(2.0, 2.0)
//                    star.layer.transform = CATransform3DMakeScale(4, 4, 1.0)
                    }, completion: nil)
                
                UIView.animateWithDuration(fadeTime, delay: 0.0, options: nil, animations: {
                    star.alpha = 1.0
                    }, completion: nil)
                
                UIView.animateWithDuration(0.5, delay: fadeTime, options: nil, animations: {
                    star.alpha = 0.0
                    }, completion: nil)
            })
        }
        
        // Wait 2 seconds till we're sure the stars are offscreen
        delay(2.0, {
            self.removeFromSuperview()
        })
    }
}

class DreamViewController: UIViewController {
    // Star container for initial burst
    var burstViews = [BurstView]()
    
    // Animator and gravity generator
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    
    @IBOutlet var btnBack: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let singleTap = UILongPressGestureRecognizer(target: self, action: "singleTap:")
        let longPress = UILongPressGestureRecognizer(target: self, action: "longPress:")
        
        singleTap.minimumPressDuration = 0.0
        
        self.view.addGestureRecognizer(singleTap)
        self.view.addGestureRecognizer(longPress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backTa(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // A single tap will start recording
    func singleTap(gesture: UILongPressGestureRecognizer) {
        // Save the gesture point
        let gesturePoint = gesture.locationInView(self.view)
        
        // Create the new view
        let starView = BurstView(frame: self.view.frame)
        
        // Create each of the stars
        for x in 0...randomIntBetweenNumbers(minStars, maxStars) {
            // Calculate frame and generate star
            let curSize = randomFloatBetweenNumbers(minSize, maxSize)
            let curRect = CGRect(origin: CGPointZero, size: CGSize(width: curSize, height: curSize))
            let curStar = DreamRightSK.imageOfLoneStar(curRect)
            
            starView.addImage(curStar, center: gesturePoint)
        }
        
        // Burst each of the stars out
        self.view.addSubview(starView)
        self.view.bringSubviewToFront(btnBack)
        starView.explode()
        
        // Add each star to the
    }
    
    // A long press initiates a the end of a dream
    func longPress(gesture: UILongPressGestureRecognizer) {
        
    }
}