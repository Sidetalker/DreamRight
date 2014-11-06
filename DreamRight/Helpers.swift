//
//  Helpers.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/5/14.
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
    var runArrayCT = CTLineGetGlyphRuns(line)
    var runArrayNS = runArrayCT as Array
    
    for var x = 0; x < runArrayNS.count; x++ {
        let runCT = runArrayNS[x] as CTRunRef
        let runPT = CFArrayGetValueAtIndex(runArrayCT, x)
        
        let attributesDict = CTRunGetAttributes(runCT) as Dictionary
        
        let runFont = attributesDict[kCTFontAttributeName] as CTFontRef
        let glyphCount = Int(CTRunGetGlyphCount(runCT))
        
        for var y = 0; y < glyphCount; y++ {
            let range = CFRangeMake(y, 1)
            var glyph = CGGlyph()
            var position = CGPoint()
            
            CTRunGetGlyphs(runCT, range, &glyph)
            CTRunGetPositions(runCT, range, &position)
            
            var letter = CTFontCreatePathForGlyph(runFont, glyph, nil)
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
    pathLayer.strokeColor = DreamRightSK.color2.CGColor
    pathLayer.fillColor = UIColor.clearColor().CGColor
    pathLayer.lineWidth = 0.8
    pathLayer.lineJoin = kCALineJoinRound
    
    return pathLayer
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

