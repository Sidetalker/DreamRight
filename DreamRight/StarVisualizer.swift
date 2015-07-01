//
//  StarVisualizer.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 11/26/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

let starCount = 5

class StarVisualizer: EZAudioPlot {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func setSampleData(data: UnsafeMutablePointer<Float>, length: Int32) {
        print("First data point: \(fabsf(data[0]))", appendNewline: false)
    }
}