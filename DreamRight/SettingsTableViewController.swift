//
//  SettingsTableViewController.swift
//  DreamRight
//
//  Created by Kevin Sullivan on 8/18/15.
//  Copyright © 2015 SideApps. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    override func viewDidLoad() {
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row == 0 {
            return tableView.dequeueReusableCellWithIdentifier("silenceTimeout")!
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return tableView.dequeueReusableCellWithIdentifier("header")!
        }
        
        return UIView()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        }
        
        return 0
    }
}
