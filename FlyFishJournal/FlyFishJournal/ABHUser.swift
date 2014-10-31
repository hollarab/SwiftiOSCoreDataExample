//
//  ABHUser.swift
//  FlyFishJournal
//
//  Created by hollarab on 10/31/14.
//  Copyright (c) 2014 a. brooks hollar. All rights reserved.
//

import Foundation
import CoreData

class ABHUser: ABHManagedObject {

    @NSManaged var username: String?
    @NSManaged var entries: NSSet
    
    func addEntry(entry:ABHEntry) {
        var mutableItems = self.mutableSetValueForKey("entries")
        mutableItems.addObject(entry)
    }

}
