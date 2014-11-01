//
//  ViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 10/31/14.
//  Copyright (c) 2014 SideApps. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var moonImage: UIImageView!
    
    // MARK: - Variables

    // MARK: - UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(1.0, delay: 0.11, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.moonImage.frame = CGRect(x: self.view.frame.width / 2 - 2400, y: self.view.frame.height / 2 - 4081, width: 12500, height: 12500)
            print("moonImage frame: \(self.moonImage.frame)")
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        return
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}