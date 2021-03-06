//
//  DreamRightSK.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/17/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class DreamRightSK : NSObject {
    
    //// Cache
    
    private struct Cache {
        static var blue: UIColor = UIColor(red: 0.055, green: 0.114, blue: 0.290, alpha: 1.000)
        static var yellow: UIColor = UIColor(red: 0.992, green: 0.902, blue: 0.239, alpha: 1.000)
    }
    
    //// Colors
    
    public class var blue: UIColor { return Cache.blue }
    public class var yellow: UIColor { return Cache.yellow }
    
    //// Drawing Methods
    
    public class func drawPlayUp(frame: CGRect) {
        
        
        //// Subframes
        let group: CGRect = CGRectMake(frame.minX + 3, frame.minY + 3, frame.width - 6, frame.height - 6)
        
        
        //// Group
        //// Oval Drawing
        var ovalPath = UIBezierPath()
        ovalPath.moveToPoint(CGPointMake(group.minX + 0.85355 * group.width, group.minY + 0.85355 * group.height))
        ovalPath.addCurveToPoint(CGPointMake(group.minX + 0.85355 * group.width, group.minY + 0.14645 * group.height), controlPoint1: CGPointMake(group.minX + 1.04882 * group.width, group.minY + 0.65829 * group.height), controlPoint2: CGPointMake(group.minX + 1.04882 * group.width, group.minY + 0.34171 * group.height))
        ovalPath.addCurveToPoint(CGPointMake(group.minX + 0.14645 * group.width, group.minY + 0.14645 * group.height), controlPoint1: CGPointMake(group.minX + 0.65829 * group.width, group.minY + -0.04882 * group.height), controlPoint2: CGPointMake(group.minX + 0.34171 * group.width, group.minY + -0.04882 * group.height))
        ovalPath.addCurveToPoint(CGPointMake(group.minX + 0.14645 * group.width, group.minY + 0.85355 * group.height), controlPoint1: CGPointMake(group.minX + -0.04882 * group.width, group.minY + 0.34171 * group.height), controlPoint2: CGPointMake(group.minX + -0.04882 * group.width, group.minY + 0.65829 * group.height))
        ovalPath.addCurveToPoint(CGPointMake(group.minX + 0.85355 * group.width, group.minY + 0.85355 * group.height), controlPoint1: CGPointMake(group.minX + 0.34171 * group.width, group.minY + 1.04882 * group.height), controlPoint2: CGPointMake(group.minX + 0.65829 * group.width, group.minY + 1.04882 * group.height))
        ovalPath.closePath()
        DreamRightSK.yellow.setStroke()
        ovalPath.lineWidth = 0.8
        ovalPath.stroke()
        
        
        //// Bezier Drawing
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(group.minX + 0.66667 * group.width, group.minY + 0.49629 * group.height))
        bezierPath.addLineToPoint(CGPointMake(group.minX + 0.37500 * group.width, group.minY + 0.35045 * group.height))
        bezierPath.addLineToPoint(CGPointMake(group.minX + 0.37500 * group.width, group.minY + 0.64212 * group.height))
        bezierPath.addLineToPoint(CGPointMake(group.minX + 0.66667 * group.width, group.minY + 0.49629 * group.height))
        bezierPath.closePath()
        DreamRightSK.yellow.setFill()
        bezierPath.fill()
    }
    
    public class func drawStopUp(frame: CGRect) {
        
        
        //// Subframes
        let group: CGRect = CGRectMake(frame.minX + 3, frame.minY + 3, frame.width - 6, frame.height - 6)
        
        
        //// Group
        //// Oval Drawing
        var ovalPath = UIBezierPath()
        ovalPath.moveToPoint(CGPointMake(group.minX + 0.85355 * group.width, group.minY + 0.85355 * group.height))
        ovalPath.addCurveToPoint(CGPointMake(group.minX + 0.85355 * group.width, group.minY + 0.14645 * group.height), controlPoint1: CGPointMake(group.minX + 1.04882 * group.width, group.minY + 0.65829 * group.height), controlPoint2: CGPointMake(group.minX + 1.04882 * group.width, group.minY + 0.34171 * group.height))
        ovalPath.addCurveToPoint(CGPointMake(group.minX + 0.14645 * group.width, group.minY + 0.14645 * group.height), controlPoint1: CGPointMake(group.minX + 0.65829 * group.width, group.minY + -0.04882 * group.height), controlPoint2: CGPointMake(group.minX + 0.34171 * group.width, group.minY + -0.04882 * group.height))
        ovalPath.addCurveToPoint(CGPointMake(group.minX + 0.14645 * group.width, group.minY + 0.85355 * group.height), controlPoint1: CGPointMake(group.minX + -0.04882 * group.width, group.minY + 0.34171 * group.height), controlPoint2: CGPointMake(group.minX + -0.04882 * group.width, group.minY + 0.65829 * group.height))
        ovalPath.addCurveToPoint(CGPointMake(group.minX + 0.85355 * group.width, group.minY + 0.85355 * group.height), controlPoint1: CGPointMake(group.minX + 0.34171 * group.width, group.minY + 1.04882 * group.height), controlPoint2: CGPointMake(group.minX + 0.65829 * group.width, group.minY + 1.04882 * group.height))
        ovalPath.closePath()
        DreamRightSK.yellow.setStroke()
        ovalPath.lineWidth = 0.8
        ovalPath.stroke()
        
        
        //// Bezier Drawing
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(group.minX + 0.64386 * group.width, group.minY + 0.64205 * group.height))
        bezierPath.addLineToPoint(CGPointMake(group.minX + 0.64386 * group.width, group.minY + 0.35045 * group.height))
        bezierPath.addLineToPoint(CGPointMake(group.minX + 0.35227 * group.width, group.minY + 0.35045 * group.height))
        bezierPath.addLineToPoint(CGPointMake(group.minX + 0.35227 * group.width, group.minY + 0.64212 * group.height))
        bezierPath.addLineToPoint(CGPointMake(group.minX + 0.64386 * group.width, group.minY + 0.64205 * group.height))
        bezierPath.closePath()
        DreamRightSK.yellow.setFill()
        bezierPath.fill()
    }
    
    public class func drawIconCanvas(frame: CGRect) {
        
        
        //// Subframes
        let group: CGRect = CGRectMake(frame.minX + floor(frame.width * 0.02830 + 0.5), frame.minY + floor(frame.height * 0.02830 - 0.36) + 0.86, floor(frame.width * 0.96713 - 0.02) - floor(frame.width * 0.02830 + 0.5) + 0.52, floor(frame.height * 0.97302 + 0.5) - floor(frame.height * 0.02830 - 0.36) - 0.86)
        
        
        //// Group
        //// Moon Drawing
        var moonPath = UIBezierPath()
        moonPath.moveToPoint(CGPointMake(group.minX + 1.00000 * group.width, group.minY + 0.71616 * group.height))
        moonPath.addCurveToPoint(CGPointMake(group.minX + 0.49340 * group.width, group.minY + 0.54028 * group.height), controlPoint1: CGPointMake(group.minX + 1.00000 * group.width, group.minY + 0.71616 * group.height), controlPoint2: CGPointMake(group.minX + 0.63746 * group.width, group.minY + 0.72511 * group.height))
        moonPath.addCurveToPoint(CGPointMake(group.minX + 0.48152 * group.width, group.minY + 0.00000 * group.height), controlPoint1: CGPointMake(group.minX + 0.34935 * group.width, group.minY + 0.35546 * group.height), controlPoint2: CGPointMake(group.minX + 0.48152 * group.width, group.minY + 0.00000 * group.height))
        moonPath.addCurveToPoint(CGPointMake(group.minX + 0.20817 * group.width, group.minY + 0.11745 * group.height), controlPoint1: CGPointMake(group.minX + 0.48152 * group.width, group.minY + 0.00000 * group.height), controlPoint2: CGPointMake(group.minX + 0.35536 * group.width, group.minY + 0.01562 * group.height))
        moonPath.addCurveToPoint(CGPointMake(group.minX + 0.04179 * group.width, group.minY + 0.30538 * group.height), controlPoint1: CGPointMake(group.minX + 0.08932 * group.width, group.minY + 0.19967 * group.height), controlPoint2: CGPointMake(group.minX + 0.05367 * group.width, group.minY + 0.28189 * group.height))
        moonPath.addCurveToPoint(CGPointMake(group.minX + 0.00613 * group.width, group.minY + 0.57552 * group.height), controlPoint1: CGPointMake(group.minX + -0.00575 * group.width, group.minY + 0.39934 * group.height), controlPoint2: CGPointMake(group.minX + -0.00469 * group.width, group.minY + 0.48348 * group.height))
        moonPath.addCurveToPoint(CGPointMake(group.minX + 0.08932 * group.width, group.minY + 0.78694 * group.height), controlPoint1: CGPointMake(group.minX + 0.01757 * group.width, group.minY + 0.67279 * group.height), controlPoint2: CGPointMake(group.minX + 0.06203 * group.width, group.minY + 0.74774 * group.height))
        moonPath.addCurveToPoint(CGPointMake(group.minX + 0.31396 * group.width, group.minY + 0.95586 * group.height), controlPoint1: CGPointMake(group.minX + 0.11605 * group.width, group.minY + 0.82533 * group.height), controlPoint2: CGPointMake(group.minX + 0.20104 * group.width, group.minY + 0.90985 * group.height))
        moonPath.addCurveToPoint(CGPointMake(group.minX + 0.60713 * group.width, group.minY + 0.99724 * group.height), controlPoint1: CGPointMake(group.minX + 0.41390 * group.width, group.minY + 0.99659 * group.height), controlPoint2: CGPointMake(group.minX + 0.53361 * group.width, group.minY + 1.00540 * group.height))
        moonPath.addCurveToPoint(CGPointMake(group.minX + 0.81655 * group.width, group.minY + 0.91445 * group.height), controlPoint1: CGPointMake(group.minX + 0.68023 * group.width, group.minY + 0.98912 * group.height), controlPoint2: CGPointMake(group.minX + 0.75943 * group.width, group.minY + 0.95617 * group.height))
        moonPath.addCurveToPoint(CGPointMake(group.minX + 1.00000 * group.width, group.minY + 0.71616 * group.height), controlPoint1: CGPointMake(group.minX + 0.91810 * group.width, group.minY + 0.84027 * group.height), controlPoint2: CGPointMake(group.minX + 1.00000 * group.width, group.minY + 0.71616 * group.height))
        moonPath.closePath()
        DreamRightSK.yellow.setFill()
        moonPath.fill()
        DreamRightSK.yellow.setStroke()
        moonPath.lineWidth = 1
        moonPath.stroke()
        
        
        //// StarBig Drawing
        var starBigPath = UIBezierPath()
        starBigPath.moveToPoint(CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.24078 * group.height))
        starBigPath.addCurveToPoint(CGPointMake(group.minX + 0.19158 * group.width, group.minY + 0.29583 * group.height), controlPoint1: CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.24078 * group.height), controlPoint2: CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.27748 * group.height))
        starBigPath.addCurveToPoint(CGPointMake(group.minX + 0.24729 * group.width, group.minY + 0.31419 * group.height), controlPoint1: CGPointMake(group.minX + 0.21015 * group.width, group.minY + 0.31419 * group.height), controlPoint2: CGPointMake(group.minX + 0.24729 * group.width, group.minY + 0.31419 * group.height))
        starBigPath.addCurveToPoint(CGPointMake(group.minX + 0.19158 * group.width, group.minY + 0.33254 * group.height), controlPoint1: CGPointMake(group.minX + 0.24729 * group.width, group.minY + 0.31419 * group.height), controlPoint2: CGPointMake(group.minX + 0.21015 * group.width, group.minY + 0.31419 * group.height))
        starBigPath.addCurveToPoint(CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.38759 * group.height), controlPoint1: CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.35089 * group.height), controlPoint2: CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.38759 * group.height))
        starBigPath.addCurveToPoint(CGPointMake(group.minX + 0.15444 * group.width, group.minY + 0.33254 * group.height), controlPoint1: CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.38759 * group.height), controlPoint2: CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.35089 * group.height))
        starBigPath.addCurveToPoint(CGPointMake(group.minX + 0.09873 * group.width, group.minY + 0.31419 * group.height), controlPoint1: CGPointMake(group.minX + 0.13587 * group.width, group.minY + 0.31419 * group.height), controlPoint2: CGPointMake(group.minX + 0.09873 * group.width, group.minY + 0.31419 * group.height))
        starBigPath.addCurveToPoint(CGPointMake(group.minX + 0.15444 * group.width, group.minY + 0.29583 * group.height), controlPoint1: CGPointMake(group.minX + 0.09873 * group.width, group.minY + 0.31419 * group.height), controlPoint2: CGPointMake(group.minX + 0.13587 * group.width, group.minY + 0.31419 * group.height))
        starBigPath.addCurveToPoint(CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.24078 * group.height), controlPoint1: CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.27748 * group.height), controlPoint2: CGPointMake(group.minX + 0.17301 * group.width, group.minY + 0.24078 * group.height))
        starBigPath.closePath()
        starBigPath.lineCapStyle = kCGLineCapRound;
        
        starBigPath.lineJoinStyle = kCGLineJoinBevel;
        
        DreamRightSK.blue.setFill()
        starBigPath.fill()
        DreamRightSK.blue.setStroke()
        starBigPath.lineWidth = 1
        starBigPath.stroke()
        
        
        //// StarMedium Drawing
        var starMediumPath = UIBezierPath()
        starMediumPath.moveToPoint(CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.39347 * group.height))
        starMediumPath.addCurveToPoint(CGPointMake(group.minX + 0.25249 * group.width, group.minY + 0.43531 * group.height), controlPoint1: CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.39347 * group.height), controlPoint2: CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.42136 * group.height))
        starMediumPath.addCurveToPoint(CGPointMake(group.minX + 0.29483 * group.width, group.minY + 0.44926 * group.height), controlPoint1: CGPointMake(group.minX + 0.26660 * group.width, group.minY + 0.44926 * group.height), controlPoint2: CGPointMake(group.minX + 0.29483 * group.width, group.minY + 0.44926 * group.height))
        starMediumPath.addCurveToPoint(CGPointMake(group.minX + 0.25249 * group.width, group.minY + 0.46321 * group.height), controlPoint1: CGPointMake(group.minX + 0.29483 * group.width, group.minY + 0.44926 * group.height), controlPoint2: CGPointMake(group.minX + 0.26660 * group.width, group.minY + 0.44926 * group.height))
        starMediumPath.addCurveToPoint(CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.50505 * group.height), controlPoint1: CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.47715 * group.height), controlPoint2: CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.50505 * group.height))
        starMediumPath.addCurveToPoint(CGPointMake(group.minX + 0.22427 * group.width, group.minY + 0.46321 * group.height), controlPoint1: CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.50505 * group.height), controlPoint2: CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.47715 * group.height))
        starMediumPath.addCurveToPoint(CGPointMake(group.minX + 0.18193 * group.width, group.minY + 0.44926 * group.height), controlPoint1: CGPointMake(group.minX + 0.21015 * group.width, group.minY + 0.44926 * group.height), controlPoint2: CGPointMake(group.minX + 0.18193 * group.width, group.minY + 0.44926 * group.height))
        starMediumPath.addCurveToPoint(CGPointMake(group.minX + 0.22427 * group.width, group.minY + 0.43531 * group.height), controlPoint1: CGPointMake(group.minX + 0.18193 * group.width, group.minY + 0.44926 * group.height), controlPoint2: CGPointMake(group.minX + 0.21015 * group.width, group.minY + 0.44926 * group.height))
        starMediumPath.addCurveToPoint(CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.39347 * group.height), controlPoint1: CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.42136 * group.height), controlPoint2: CGPointMake(group.minX + 0.23838 * group.width, group.minY + 0.39347 * group.height))
        starMediumPath.closePath()
        starMediumPath.lineCapStyle = kCGLineCapRound;
        
        starMediumPath.lineJoinStyle = kCGLineJoinBevel;
        
        DreamRightSK.blue.setFill()
        starMediumPath.fill()
        DreamRightSK.blue.setStroke()
        starMediumPath.lineWidth = 1
        starMediumPath.stroke()
        
        
        //// StarSmall Drawing
        var starSmallPath = UIBezierPath()
        starSmallPath.moveToPoint(CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.38172 * group.height))
        starSmallPath.addCurveToPoint(CGPointMake(group.minX + 0.11136 * group.width, group.minY + 0.41035 * group.height), controlPoint1: CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.38172 * group.height), controlPoint2: CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.40081 * group.height))
        starSmallPath.addCurveToPoint(CGPointMake(group.minX + 0.14033 * group.width, group.minY + 0.41989 * group.height), controlPoint1: CGPointMake(group.minX + 0.12102 * group.width, group.minY + 0.41989 * group.height), controlPoint2: CGPointMake(group.minX + 0.14033 * group.width, group.minY + 0.41989 * group.height))
        starSmallPath.addCurveToPoint(CGPointMake(group.minX + 0.11136 * group.width, group.minY + 0.42944 * group.height), controlPoint1: CGPointMake(group.minX + 0.14033 * group.width, group.minY + 0.41989 * group.height), controlPoint2: CGPointMake(group.minX + 0.12102 * group.width, group.minY + 0.41989 * group.height))
        starSmallPath.addCurveToPoint(CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.45807 * group.height), controlPoint1: CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.43898 * group.height), controlPoint2: CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.45807 * group.height))
        starSmallPath.addCurveToPoint(CGPointMake(group.minX + 0.09205 * group.width, group.minY + 0.42944 * group.height), controlPoint1: CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.45807 * group.height), controlPoint2: CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.43898 * group.height))
        starSmallPath.addCurveToPoint(CGPointMake(group.minX + 0.06308 * group.width, group.minY + 0.41989 * group.height), controlPoint1: CGPointMake(group.minX + 0.08239 * group.width, group.minY + 0.41989 * group.height), controlPoint2: CGPointMake(group.minX + 0.06308 * group.width, group.minY + 0.41989 * group.height))
        starSmallPath.addCurveToPoint(CGPointMake(group.minX + 0.09205 * group.width, group.minY + 0.41035 * group.height), controlPoint1: CGPointMake(group.minX + 0.06308 * group.width, group.minY + 0.41989 * group.height), controlPoint2: CGPointMake(group.minX + 0.08239 * group.width, group.minY + 0.41989 * group.height))
        starSmallPath.addCurveToPoint(CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.38172 * group.height), controlPoint1: CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.40081 * group.height), controlPoint2: CGPointMake(group.minX + 0.10171 * group.width, group.minY + 0.38172 * group.height))
        starSmallPath.closePath()
        starSmallPath.lineCapStyle = kCGLineCapRound;
        
        starSmallPath.lineJoinStyle = kCGLineJoinBevel;
        
        DreamRightSK.blue.setFill()
        starSmallPath.fill()
        DreamRightSK.blue.setStroke()
        starSmallPath.lineWidth = 1
        starSmallPath.stroke()
    }
    
    public class func drawLoneStar(frame: CGRect) {
        
        //// StarBig Drawing
        var starBigPath = UIBezierPath()
        starBigPath.moveToPoint(CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.02941 * frame.height))
        starBigPath.addCurveToPoint(CGPointMake(frame.minX + 0.61765 * frame.width, frame.minY + 0.38235 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.02941 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.26471 * frame.height))
        starBigPath.addCurveToPoint(CGPointMake(frame.minX + 0.97059 * frame.width, frame.minY + 0.50000 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.73529 * frame.width, frame.minY + 0.50000 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.97059 * frame.width, frame.minY + 0.50000 * frame.height))
        starBigPath.addCurveToPoint(CGPointMake(frame.minX + 0.61765 * frame.width, frame.minY + 0.61765 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.97059 * frame.width, frame.minY + 0.50000 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.73529 * frame.width, frame.minY + 0.50000 * frame.height))
        starBigPath.addCurveToPoint(CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.97059 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.73529 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.97059 * frame.height))
        starBigPath.addCurveToPoint(CGPointMake(frame.minX + 0.38235 * frame.width, frame.minY + 0.61765 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.97059 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.73529 * frame.height))
        starBigPath.addCurveToPoint(CGPointMake(frame.minX + 0.02941 * frame.width, frame.minY + 0.50000 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.26471 * frame.width, frame.minY + 0.50000 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.02941 * frame.width, frame.minY + 0.50000 * frame.height))
        starBigPath.addCurveToPoint(CGPointMake(frame.minX + 0.38235 * frame.width, frame.minY + 0.38235 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.02941 * frame.width, frame.minY + 0.50000 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.26471 * frame.width, frame.minY + 0.50000 * frame.height))
        starBigPath.addCurveToPoint(CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.02941 * frame.height), controlPoint1: CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.26471 * frame.height), controlPoint2: CGPointMake(frame.minX + 0.50000 * frame.width, frame.minY + 0.02941 * frame.height))
        starBigPath.closePath()
        starBigPath.lineCapStyle = kCGLineCapRound;
        
        starBigPath.lineJoinStyle = kCGLineJoinBevel;
        
        DreamRightSK.yellow.setFill()
        starBigPath.fill()
        DreamRightSK.yellow.setStroke()
        starBigPath.lineWidth = 1
        starBigPath.stroke()
    }
    
    public class func drawSun() {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Polygon Drawing
        var polygonPath = UIBezierPath()
        polygonPath.moveToPoint(CGPointMake(122, 8))
        polygonPath.addLineToPoint(CGPointMake(143.65, 45.5))
        polygonPath.addLineToPoint(CGPointMake(100.35, 45.5))
        polygonPath.closePath()
        DreamRightSK.yellow.setFill()
        polygonPath.fill()
        
        
        //// Polygon 2 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 186, 24.64)
        CGContextRotateCTM(context, 45 * CGFloat(M_PI) / 180)
        
        var polygon2Path = UIBezierPath()
        polygon2Path.moveToPoint(CGPointMake(25, 0))
        polygon2Path.addLineToPoint(CGPointMake(46.65, 37.5))
        polygon2Path.addLineToPoint(CGPointMake(3.35, 37.5))
        polygon2Path.closePath()
        DreamRightSK.yellow.setFill()
        polygon2Path.fill()
        
        CGContextRestoreGState(context)
        
        
        //// Polygon 3 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 238, 99)
        CGContextRotateCTM(context, 90 * CGFloat(M_PI) / 180)
        
        var polygon3Path = UIBezierPath()
        polygon3Path.moveToPoint(CGPointMake(25, 0))
        polygon3Path.addLineToPoint(CGPointMake(46.65, 37.5))
        polygon3Path.addLineToPoint(CGPointMake(3.35, 37.5))
        polygon3Path.closePath()
        DreamRightSK.yellow.setFill()
        polygon3Path.fill()
        
        CGContextRestoreGState(context)
        
        
        //// Polygon 4 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 221.36, 186)
        CGContextRotateCTM(context, 135 * CGFloat(M_PI) / 180)
        
        var polygon4Path = UIBezierPath()
        polygon4Path.moveToPoint(CGPointMake(25, 0))
        polygon4Path.addLineToPoint(CGPointMake(46.65, 37.5))
        polygon4Path.addLineToPoint(CGPointMake(3.35, 37.5))
        polygon4Path.closePath()
        DreamRightSK.yellow.setFill()
        polygon4Path.fill()
        
        CGContextRestoreGState(context)
        
        
        //// Polygon 5 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 147, 240)
        CGContextRotateCTM(context, 180 * CGFloat(M_PI) / 180)
        
        var polygon5Path = UIBezierPath()
        polygon5Path.moveToPoint(CGPointMake(25, 0))
        polygon5Path.addLineToPoint(CGPointMake(46.65, 37.5))
        polygon5Path.addLineToPoint(CGPointMake(3.35, 37.5))
        polygon5Path.closePath()
        DreamRightSK.yellow.setFill()
        polygon5Path.fill()
        
        CGContextRestoreGState(context)
        
        
        //// Polygon 6 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 6, 149)
        CGContextRotateCTM(context, -90 * CGFloat(M_PI) / 180)
        
        var polygon6Path = UIBezierPath()
        polygon6Path.moveToPoint(CGPointMake(25, 0))
        polygon6Path.addLineToPoint(CGPointMake(46.65, 37.5))
        polygon6Path.addLineToPoint(CGPointMake(3.35, 37.5))
        polygon6Path.closePath()
        DreamRightSK.yellow.setFill()
        polygon6Path.fill()
        
        CGContextRestoreGState(context)
        
        
        //// Polygon 7 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 57, 221.36)
        CGContextRotateCTM(context, -135 * CGFloat(M_PI) / 180)
        
        var polygon7Path = UIBezierPath()
        polygon7Path.moveToPoint(CGPointMake(25, 0))
        polygon7Path.addLineToPoint(CGPointMake(46.65, 37.5))
        polygon7Path.addLineToPoint(CGPointMake(3.35, 37.5))
        polygon7Path.closePath()
        DreamRightSK.yellow.setFill()
        polygon7Path.fill()
        
        CGContextRestoreGState(context)
        
        
        //// Polygon 8 Drawing
        CGContextSaveGState(context)
        CGContextTranslateCTM(context, 21.64, 60)
        CGContextRotateCTM(context, -45 * CGFloat(M_PI) / 180)
        
        var polygon8Path = UIBezierPath()
        polygon8Path.moveToPoint(CGPointMake(25, 0))
        polygon8Path.addLineToPoint(CGPointMake(46.65, 37.5))
        polygon8Path.addLineToPoint(CGPointMake(3.35, 37.5))
        polygon8Path.closePath()
        DreamRightSK.yellow.setFill()
        polygon8Path.fill()
        
        CGContextRestoreGState(context)
        
        
        //// Oval Drawing
        var ovalPath = UIBezierPath(ovalInRect: CGRectMake(40, 42, 164, 164))
        DreamRightSK.yellow.setFill()
        ovalPath.fill()
    }
    
    //// Generated Images
    
    public class func imageOfPlayUp(frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        DreamRightSK.drawPlayUp(frame)
        var imageOfPlayUp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfPlayUp!
    }
    
    public class func imageOfStopUp(frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        DreamRightSK.drawStopUp(frame)
        var imageOfStopUp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfStopUp!
    }
    
    public class func imageOfIconCanvas(frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        DreamRightSK.drawIconCanvas(frame)
        var imageOfIconCanvas = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfIconCanvas!
    }
    
    public class func imageOfLoneStar(frame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        DreamRightSK.drawLoneStar(frame)
        var imageOfLoneStar = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfLoneStar!
    }
    
}

@objc protocol StyleKitSettableImage {
    var image: UIImage! { get set }
}

@objc protocol StyleKitSettableSelectedImage {
    var selectedImage: UIImage! { get set }
}
