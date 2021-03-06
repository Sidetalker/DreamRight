//
//  StyleKitName.swift
//  ProjectName
//
//  Created by AuthorName on 11/2/14.
//  Copyright (c) 2014 CompanyName. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class StyleKitName : NSObject {

    //// Drawing Methods

    public class func drawCanvas1() {
        //// Color Declarations
        let color = UIColor(red: 0.055, green: 0.114, blue: 0.290, alpha: 1.000)
        let color2 = UIColor(red: 0.992, green: 0.902, blue: 0.239, alpha: 1.000)

        //// Bezier Drawing
        var bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(81.94, 63.78))
        bezierPath.addCurveToPoint(CGPointMake(41.5, 46.5), controlPoint1: CGPointMake(81.94, 63.78), controlPoint2: CGPointMake(53.62, 62.24))
        bezierPath.addCurveToPoint(CGPointMake(40.5, 0.5), controlPoint1: CGPointMake(29.38, 30.76), controlPoint2: CGPointMake(40.5, 0.5))
        bezierPath.addCurveToPoint(CGPointMake(17.5, 10.5), controlPoint1: CGPointMake(40.5, 0.5), controlPoint2: CGPointMake(29.89, 1.83))
        bezierPath.addCurveToPoint(CGPointMake(3.5, 26.5), controlPoint1: CGPointMake(7.5, 17.5), controlPoint2: CGPointMake(4.5, 24.5))
        bezierPath.addCurveToPoint(CGPointMake(0.5, 49.5), controlPoint1: CGPointMake(-0.5, 34.5), controlPoint2: CGPointMake(-0.41, 41.66))
        bezierPath.addCurveToPoint(CGPointMake(7.5, 67.5), controlPoint1: CGPointMake(1.46, 57.78), controlPoint2: CGPointMake(5.2, 64.16))
        bezierPath.addCurveToPoint(CGPointMake(26.4, 81.88), controlPoint1: CGPointMake(9.75, 70.77), controlPoint2: CGPointMake(16.9, 77.96))
        bezierPath.addCurveToPoint(CGPointMake(51.07, 85.41), controlPoint1: CGPointMake(34.81, 85.35), controlPoint2: CGPointMake(44.88, 86.1))
        bezierPath.addCurveToPoint(CGPointMake(68.69, 78.36), controlPoint1: CGPointMake(57.22, 84.71), controlPoint2: CGPointMake(63.88, 81.91))
        bezierPath.addCurveToPoint(CGPointMake(81.94, 63.78), controlPoint1: CGPointMake(77.23, 72.04), controlPoint2: CGPointMake(81.94, 63.78))
        bezierPath.closePath()
        color2.setFill()
        bezierPath.fill()
        color2.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()


        //// Star Drawing
        var starPath = UIBezierPath()
        starPath.moveToPoint(CGPointMake(16.25, 21))
        starPath.addCurveToPoint(CGPointMake(17.81, 25.69), controlPoint1: CGPointMake(16.25, 21), controlPoint2: CGPointMake(16.25, 24.12))
        starPath.addCurveToPoint(CGPointMake(22.5, 27.25), controlPoint1: CGPointMake(19.38, 27.25), controlPoint2: CGPointMake(22.5, 27.25))
        starPath.addCurveToPoint(CGPointMake(17.81, 28.81), controlPoint1: CGPointMake(22.5, 27.25), controlPoint2: CGPointMake(19.38, 27.25))
        starPath.addCurveToPoint(CGPointMake(16.25, 33.5), controlPoint1: CGPointMake(16.25, 30.38), controlPoint2: CGPointMake(16.25, 33.5))
        starPath.addCurveToPoint(CGPointMake(14.69, 28.81), controlPoint1: CGPointMake(16.25, 33.5), controlPoint2: CGPointMake(16.25, 30.38))
        starPath.addCurveToPoint(CGPointMake(10, 27.25), controlPoint1: CGPointMake(13.12, 27.25), controlPoint2: CGPointMake(10, 27.25))
        starPath.addCurveToPoint(CGPointMake(14.69, 25.69), controlPoint1: CGPointMake(10, 27.25), controlPoint2: CGPointMake(13.12, 27.25))
        starPath.addCurveToPoint(CGPointMake(16.25, 21), controlPoint1: CGPointMake(16.25, 24.12), controlPoint2: CGPointMake(16.25, 21))
        starPath.closePath()
        starPath.lineCapStyle = kCGLineCapRound;

        starPath.lineJoinStyle = kCGLineJoinBevel;

        color.setFill()
        starPath.fill()
        color.setStroke()
        starPath.lineWidth = 1
        starPath.stroke()


        //// Star 2 Drawing
        var star2Path = UIBezierPath()
        star2Path.moveToPoint(CGPointMake(21.75, 34))
        star2Path.addCurveToPoint(CGPointMake(22.94, 37.56), controlPoint1: CGPointMake(21.75, 34), controlPoint2: CGPointMake(21.75, 36.38))
        star2Path.addCurveToPoint(CGPointMake(26.5, 38.75), controlPoint1: CGPointMake(24.12, 38.75), controlPoint2: CGPointMake(26.5, 38.75))
        star2Path.addCurveToPoint(CGPointMake(22.94, 39.94), controlPoint1: CGPointMake(26.5, 38.75), controlPoint2: CGPointMake(24.12, 38.75))
        star2Path.addCurveToPoint(CGPointMake(21.75, 43.5), controlPoint1: CGPointMake(21.75, 41.12), controlPoint2: CGPointMake(21.75, 43.5))
        star2Path.addCurveToPoint(CGPointMake(20.56, 39.94), controlPoint1: CGPointMake(21.75, 43.5), controlPoint2: CGPointMake(21.75, 41.12))
        star2Path.addCurveToPoint(CGPointMake(17, 38.75), controlPoint1: CGPointMake(19.38, 38.75), controlPoint2: CGPointMake(17, 38.75))
        star2Path.addCurveToPoint(CGPointMake(20.56, 37.56), controlPoint1: CGPointMake(17, 38.75), controlPoint2: CGPointMake(19.38, 38.75))
        star2Path.addCurveToPoint(CGPointMake(21.75, 34), controlPoint1: CGPointMake(21.75, 36.38), controlPoint2: CGPointMake(21.75, 34))
        star2Path.closePath()
        star2Path.lineCapStyle = kCGLineCapRound;

        star2Path.lineJoinStyle = kCGLineJoinBevel;

        color.setFill()
        star2Path.fill()
        color.setStroke()
        star2Path.lineWidth = 1
        star2Path.stroke()


        //// Star 3 Drawing
        var star3Path = UIBezierPath()
        star3Path.moveToPoint(CGPointMake(10.25, 33))
        star3Path.addCurveToPoint(CGPointMake(11.06, 35.44), controlPoint1: CGPointMake(10.25, 33), controlPoint2: CGPointMake(10.25, 34.62))
        star3Path.addCurveToPoint(CGPointMake(13.5, 36.25), controlPoint1: CGPointMake(11.88, 36.25), controlPoint2: CGPointMake(13.5, 36.25))
        star3Path.addCurveToPoint(CGPointMake(11.06, 37.06), controlPoint1: CGPointMake(13.5, 36.25), controlPoint2: CGPointMake(11.88, 36.25))
        star3Path.addCurveToPoint(CGPointMake(10.25, 39.5), controlPoint1: CGPointMake(10.25, 37.88), controlPoint2: CGPointMake(10.25, 39.5))
        star3Path.addCurveToPoint(CGPointMake(9.44, 37.06), controlPoint1: CGPointMake(10.25, 39.5), controlPoint2: CGPointMake(10.25, 37.88))
        star3Path.addCurveToPoint(CGPointMake(7, 36.25), controlPoint1: CGPointMake(8.62, 36.25), controlPoint2: CGPointMake(7, 36.25))
        star3Path.addCurveToPoint(CGPointMake(9.44, 35.44), controlPoint1: CGPointMake(7, 36.25), controlPoint2: CGPointMake(8.62, 36.25))
        star3Path.addCurveToPoint(CGPointMake(10.25, 33), controlPoint1: CGPointMake(10.25, 34.62), controlPoint2: CGPointMake(10.25, 33))
        star3Path.closePath()
        star3Path.lineCapStyle = kCGLineCapRound;

        star3Path.lineJoinStyle = kCGLineJoinBevel;

        color.setFill()
        star3Path.fill()
        color.setStroke()
        star3Path.lineWidth = 1
        star3Path.stroke()
    }

}

@objc protocol StyleKitSettableImage {
    var image: UIImage! { get set }
}

@objc protocol StyleKitSettableSelectedImage {
    var selectedImage: UIImage! { get set }
}
