//
//  Night+CoreDataProperties.swift
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

extension Night {

    @NSManaged var date: NSDate?
    @NSManaged var name: String?
    @NSManaged var dream: NSSet?

}
