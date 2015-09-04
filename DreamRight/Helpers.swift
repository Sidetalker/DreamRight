//
//  Helpers.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/5/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit
import CoreData

// NSUserDefaults
struct Settings {
    var previousAppVersion: String?
    var currentAppVersion: String?
    
    var silenceTimeout: Int?
}

func writeDefaults(data: Settings) -> Bool {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    defaults.setObject(data.previousAppVersion, forKey: "previousAppVersion")
    defaults.setObject(data.currentAppVersion, forKey: "currentAppVersion")
    
    defaults.setObject(data.silenceTimeout, forKey: "silenceTimeout")
    
    return true
}

func readDefaults() -> Settings {
    let defaults = NSUserDefaults.standardUserDefaults()
    var save = Settings()
    
    save.previousAppVersion = defaults.stringForKey("previousAppVersion")
    save.currentAppVersion = defaults.stringForKey("currentAppVersion")
    
    save.silenceTimeout = defaults.integerForKey("silenceTimeout")

    return save
}

func validateDefaults(save: Settings) -> Settings {
    var newSave = save
    
    let version = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    newSave.currentAppVersion = version
    
    // New Install
    if save.previousAppVersion == nil {
        print("First install - loading default settings")
    }
    // New Update
    else if save.previousAppVersion! != save.currentAppVersion! {
        print("App already exists (update) and we got our settings!")
    }
    
    newSave.previousAppVersion = version
    
    if newSave.silenceTimeout == nil {
        newSave.silenceTimeout = 10
    }
    
    return newSave
}

let managedObjectContext: NSManagedObjectContext? = {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    if let managedObjectContext = appDelegate.managedObjectContext { return managedObjectContext }
    else { return nil } }()

// Inserts an object into the CoreData stack and the new object
func insertObject(name: String) -> AnyObject {
    return NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: managedObjectContext!)
}

// Fetches all specified records from the CoreData stack
func getObjects(name: String, predicate: NSPredicate?) -> [AnyObject] {
    let fetchRequest = NSFetchRequest(entityName: name)
    fetchRequest.predicate = predicate
    
    do {
        return try managedObjectContext!.executeFetchRequest(fetchRequest)
    }
    catch {
        print("Couldn't retrieve objects")
    }
    
    return []
}

// Saves the CoreData stacks
func save() {
    do {
        try managedObjectContext!.save()
    }
    catch {
        print("Couldn't save m8, piss off")
    }
}

// Rolls back the CoreData stack to the last save
func rollback() {
    managedObjectContext!.rollback()
}

extension String {
    var floatValue: CGFloat {
        return CGFloat((self as NSString).floatValue)
    }
}

func randomFloatBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
}

func randomIntBetweenNumbers(firstNum: Int, secondNum: Int) -> Int {
    let first = CGFloat(firstNum)
    let second = CGFloat(secondNum)
    let random = randomFloatBetweenNumbers(first, secondNum: second)
    
    return Int(random)
}

struct Star {
    var view: UIImageView
    var baseImage: UIImage?
    var finalImage: UIImage?
    var delay: NSTimeInterval
    var time: NSTimeInterval
    var animationOptions: UIViewAnimationOptions
    var baseFrame: CGRect
    var finalFrame: CGRect
    
    func transition(forward: Bool, twinkle: Bool) {
        let timing = Double(randomFloatBetweenNumbers(1.1, secondNum: 1.5))
        let angle = Double(randomFloatBetweenNumbers(1, secondNum: 5))
        
        self.view.frame = CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y, width: 0.1, height: 0.1)
        
        let rotation = -CGFloat(angle / 180 * M_PI)
        let scale = self.finalFrame.width * 10
        
        let bonusDelay = delay + delay * Double(randomFloatBetweenNumbers(0.3, secondNum: 3))
        
        UIView.animateWithDuration(time, delay: bonusDelay, options: animationOptions, animations: {
            let rotationTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotation)
            let sizeTransform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale)
            let bothTransforms = CGAffineTransformConcat(rotationTransform, sizeTransform)
            
            self.view.transform = bothTransforms
            
            }, completion: {
                (value: Bool) in
                if value && twinkle {
                    self.twinkle(true, timing: timing, angle: Double(scale), chance: 7, scale: scale)
                }
        })
    }
    
    func twinkle(start: Bool, timing: Double, angle: Double, chance: CGFloat, scale: CGFloat) {
        let fullDuration = CFTimeInterval(timing)
        
        let rotationFull = angle
        var rotationRightFull = CGFloat(rotationFull / 180 * M_PI)
        var rotationLeftFull = -rotationRightFull
        let sizeMod = randomFloatBetweenNumbers(0.75, secondNum: 1.25)
        
        let returnChance = Int(randomFloatBetweenNumbers(1, secondNum: chance))
        
        if returnChance != 1 {
            self.twinkle(false, timing: timing, angle: angle, chance: 3, scale: scale)
            return
        }
        
        if Int(randomFloatBetweenNumbers(1, secondNum: 2)) % 2 == 0 {
            rotationLeftFull = -rotationLeftFull
            rotationRightFull = -rotationRightFull
        }
        
        UIView.animateWithDuration(fullDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            let rotationTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotationLeftFull)
            let sizeTransform = CGAffineTransformScale(CGAffineTransformIdentity, CGFloat(scale * sizeMod), CGFloat(scale * sizeMod))
            let bothTransforms = CGAffineTransformConcat(rotationTransform, sizeTransform)
            self.view.transform = bothTransforms
            
            }, completion: nil)
        
        UIView.animateWithDuration(fullDuration, delay: fullDuration, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            let rotationTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotationRightFull)
            self.view.transform = rotationTransform
            
            }, completion: nil)
        
        UIView.animateWithDuration(fullDuration / 2, delay: fullDuration * 2, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            let rotationTransform = CGAffineTransformRotate(CGAffineTransformIdentity, rotationLeftFull / 2)
            self.view.transform = rotationTransform
            
            }, completion: {
                (value: Bool) in
                if value {
                    self.twinkle(true, timing: timing, angle: angle, chance: 5, scale: scale)
                }
        })
    }
}

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
        
        if starSizeMinA > starSizeMaxA || starSizeMinB > starSizeMaxB {
            return stars
        }
        
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

func createDrawableString(formattedString: NSAttributedString, frame: CGRect) -> CAShapeLayer {
    let letters = CGPathCreateMutable()
    
    let line = CTLineCreateWithAttributedString(formattedString)
    let runArrayCT = CTLineGetGlyphRuns(line)
    var runArrayNS = runArrayCT as Array
    
    for var x = 0; x < runArrayNS.count; x++ {
        let runCT = runArrayNS[x] as! CTRunRef
        
        let attributesDict = CTRunGetAttributes(runCT) as Dictionary
        
        let runFont = attributesDict[kCTFontAttributeName] as! CTFontRef
        let glyphCount = Int(CTRunGetGlyphCount(runCT))
        
        for var y = 0; y < glyphCount; y++ {
            let range = CFRangeMake(y, 1)
            var glyph = CGGlyph()
            var position = CGPoint()
            
            CTRunGetGlyphs(runCT, range, &glyph)
            CTRunGetPositions(runCT, range, &position)
            
            let letter = CTFontCreatePathForGlyph(runFont, glyph, nil)
            var transform = CGAffineTransformMakeTranslation(position.x, position.y)
            
            CGPathAddPath(letters, &transform, letter)
        }
    }
    
    let path = UIBezierPath()
    path.moveToPoint(CGPointZero)
    path.appendPath(UIBezierPath(CGPath: letters))
    
    let pathLayer = CAShapeLayer()
    pathLayer.frame = frame
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath)
    pathLayer.backgroundColor = UIColor.clearColor().CGColor
    pathLayer.geometryFlipped = true
    pathLayer.path = path.CGPath
    pathLayer.strokeColor = DreamRightSK.yellow.CGColor
    pathLayer.fillColor = UIColor.clearColor().CGColor
    pathLayer.lineWidth = 0.8
    pathLayer.lineJoin = kCALineJoinRound
    
    return pathLayer
}

func delay(delay: Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

extension UIView {
    class func initWithNibName<T>(nibName: String) -> T {
        
        let viewsInNib = NSBundle.mainBundle().loadNibNamed(nibName, owner: self, options: nil)
        
        var returnView: T!
        for view in viewsInNib {
            if let view = view as? T {
                returnView = view
                break
            }
        }
        return returnView
    }
}

// Takes a UIView jiggles it back and forth
func jiggle(element: UIView, count: Int, distance: CGFloat) {
    // Save variables for frame offset calculation
    let originalFrame = element.frame
    let constantSize = originalFrame.size
    let originalOrigin = originalFrame.origin
    let leftOrigin = originalOrigin.x - distance
    let rightOrigin = originalOrigin.x + distance
    
    // Calculate frame offsets
    let frameLeft = CGRect(origin: CGPoint(x: leftOrigin, y: originalOrigin.y), size: constantSize)
    let frameRight = CGRect(origin: CGPoint(x: rightOrigin, y: originalOrigin.y), size: constantSize)
    
    // Perform "count" shakes
    for x in 0...count {
        let delay = Double(x) / Double(count) / 2
        var destinationFrame = CGRect()
        
        if x == count { destinationFrame = originalFrame } // Restore original frame in last loop
        else if x % 2 == 0 { destinationFrame = frameRight } // Jiggle right on evens
        else { destinationFrame = frameLeft } // Jiggle left on odds
        
        // Fire the animation block
        UIView.animateWithDuration(0.1, delay: delay, options: UIViewAnimationOptions.CurveLinear, animations: {
            // Update the element's frame
            element.frame = destinationFrame
            }, completion: nil)
    }
}

// Takes an NSDate and returns a verbose description of the day
func dateToNightText(date: NSDate) -> String {
    // Prepare to format the date
    let format = NSDateFormatter()
    format.dateFormat = "EEEE, MMMM d, yyyy"
    
    // Apply the formatting to the entry's date
    return format.stringFromDate(date)
}

// Takes an NSDate and returns a verbose description of the time of day
func dateToDreamText(date: NSDate) -> String {
    // Prepare to format the date
    let format = NSDateFormatter()
    format.dateFormat = "h:mm:ss a"
    
    // Apply the formatting to the entry's date
    return format.stringFromDate(date)
}
