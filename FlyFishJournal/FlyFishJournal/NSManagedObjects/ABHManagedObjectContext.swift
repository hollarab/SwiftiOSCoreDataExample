//
//  ABHManagedObject.swift
//  FlyFishJournal
//
//  Created by hollarab on 10/27/14.
//  Copyright (c) 2014 a. brooks hollar. All rights reserved.
//

import UIKit
import CoreData

class ABHManagedObjectContext: NSManagedObjectContext {

    class func modelName() -> String? {
        return "FlyFishJournal"
    }
    
    class func createAt(storeURL:NSURL?, options:[NSObject:AnyObject]?) -> ABHManagedObjectContext {
      // Load merged models
        var models:[NSManagedObjectModel] = []
        var modelString = modelName()
        assert(modelString != nil, "must implement +modelName()")
        
        // passing nil gives you in-memory variant
        var storeType = storeURL == nil ? NSInMemoryStoreType : NSSQLiteStoreType;
        
        // code written to easily support multiple models
        var modelURL = NSBundle.mainBundle().URLForResource(modelString!, withExtension:"momd")
        assert(modelURL != nil, "Could not find model named \(modelString!)")
        
        var model = NSManagedObjectModel(contentsOfURL: modelURL!)
        assert(model != nil, "Couldn't load model at '\(modelURL!)'")
        
        models.append(model!)
        
        var mergedModel = NSManagedObjectModel(byMergingModels: models)

      // Instanciate PSC
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: mergedModel!)
        
      // Add Stores
        var error: NSError? = nil
        var store:NSPersistentStore? = coordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: options, error: &error)
        
        assert(store != nil, "Store error: \(error?.description)")
        
      // Create Context
        var context = ABHManagedObjectContext()
        context.persistentStoreCoordinator = coordinator
        return context
    }
    
    class func createInMemory() -> ABHManagedObjectContext {
        return createAt(nil, options: nil)
    }
}
