//
//  ABHEntry.swift
//  FlyFishJournal
//
//  Created by hollarab on 10/27/14.
//  Copyright (c) 2014 a. brooks hollar. All rights reserved.
//

import Foundation
import CoreData

class ABHEntry: ABHManagedObject {

    @NSManaged var timeStamp: NSDate?
    @NSManaged var text: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var title: String?

    override class var entityName:String {
        return "ABHEntry"
    }
    
    override class func sortDescriptors() -> [AnyObject]? {
        return [NSSortDescriptor(key: "timeStamp", ascending: false)]
    }
}
