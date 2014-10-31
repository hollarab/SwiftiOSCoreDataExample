//
//  ABHv2to3MigrationPolicy.swift
//  FlyFishJournal
//
//  Created by hollarab on 10/31/14.
//  Copyright (c) 2014 a. brooks hollar. All rights reserved.
//

import UIKit
import CoreData  // have to add this

class ABHv2to3MigrationPolicy: NSEntityMigrationPolicy {
    
    override func beginEntityMapping(mapping: NSEntityMapping, manager: NSMigrationManager, error:NSErrorPointer) -> Bool {
            
        return true
    }
    
   
    /* Invoked by the migration manager on each source instance (as specified by the sourceExpression in the mapping) to create the corresponding destination instance.  The method also associates the source and destination instances by calling NSMigrationManager's
    associateSourceInstance:withDestinationInstance:forEntityMapping: method.  Subclass implementations of this method must be careful to
    associate the source and destination instances as required if super is not called. A return value of NO indicates an error.
    */
    override func createDestinationInstancesForSourceInstance(sInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager, error: NSErrorPointer) -> Bool {
        
        let destMOC:NSManagedObjectContext = manager.destinationContext
        let destEntityName:String? = mapping.destinationEntityName

        var userInfo:[NSObject:AnyObject]? = manager.userInfo
        if userInfo == nil {
            userInfo = Dictionary()
            manager.userInfo = userInfo
        }
        
        var dInstance = ABHEntry.newInstanceInManagedObjectContext(destMOC)
        // apply values?
        
        // need to create a new one, but for now this needs to just run
        manager.associateSourceInstance(sInstance, withDestinationInstance: dInstance, forEntityMapping: mapping)
        
        return true
    }

    
    /* Constructs the relationships between the newly-created destination instances.  The association lookup methods on the NSMigrationManager can be used to determine the appropriate relationship targets.  A return value of NO indicates an error.
    */
    override func createRelationshipsForDestinationInstance(dInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager, error: NSErrorPointer) -> Bool {

        var userInfo:[NSObject:AnyObject]? = manager.userInfo
        let destMOC:NSManagedObjectContext = manager.destinationContext
        
        // get defatult user
        var userCon:ABHUser? = userInfo!["userObject"] as? ABHUser
        if userCon == nil {
            // create if it doesnt exist
            userCon = ABHUser.newInstanceInManagedObjectContext(destMOC) as? ABHUser
        }
        // add current Entry to the User's entries
        userCon!.addEntry(dInstance as ABHEntry)
        
        return true
    }

}
