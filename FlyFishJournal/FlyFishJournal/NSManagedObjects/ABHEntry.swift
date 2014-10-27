//
//  ABHEntry.swift
//  FlyFishJournal
//
//  Created by hollarab on 10/27/14.
//  Copyright (c) 2014 a. brooks hollar. All rights reserved.
//

import Foundation
import CoreData

class ABHEntry: NSManagedObject {

    @NSManaged var timeStamp: NSDate
    @NSManaged var text: String

}
