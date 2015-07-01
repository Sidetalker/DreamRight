//
//  Dream+CoreDataProperties.swift
//  
//
//  Created by Kevin Sullivan on 6/28/15.
//
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Dream {

    @NSManaged var time: NSDate?
    @NSManaged var name: String?
    @NSManaged var text: String?
    @NSManaged var recording: NSData?
    @NSManaged var night: Night?

}
