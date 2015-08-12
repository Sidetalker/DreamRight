//
//  Dream+CoreDataProperties.swift
//  
//
//  Created by Kevin Sullivan on 8/8/15.
//
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

import Foundation
import CoreData

extension Dream {

    @NSManaged var name: String?
    @NSManaged var recording: String?
    @NSManaged var text: String?
    @NSManaged var time: NSDate?
    @NSManaged var night: Night?

}
