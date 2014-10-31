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
        
        println("opening store at \(storeURL!)")
        
        // passing nil gives you in-memory variant
        var storeType = storeURL == nil ? NSInMemoryStoreType : NSSQLiteStoreType;
        
        // code written to easily support multiple models
        var modelURL = NSBundle.mainBundle().URLForResource(modelString!, withExtension:"momd")
        assert(modelURL != nil, "Could not find model named \(modelString!)")
        
//        var sourceMetadata = NSPersistentStoreCoordinator.metadataForPersistentStoreOfType(storeType, URL:storeURL!)
        var error: NSError? = nil
        var sourceMetadata:[NSObject : AnyObject]? = NSPersistentStoreCoordinator.metadataForPersistentStoreOfType(storeType,URL:storeURL!, error: &error)
        
        
        var model = NSManagedObjectModel(contentsOfURL: modelURL!)
        assert(model != nil, "Couldn't load model at '\(modelURL!)'")
        
        /*
        model.inferredMappingModelForSourceModel(_ source: NSManagedObjectModel,
            destinationModel destination: NSManagedObjectModel,
            error error: NSErrorPointer) -> NSMappingModel?
        */
        
        models.append(model!)
        
        var mergedModel = NSManagedObjectModel(byMergingModels: models)

      // Instanciate PSC
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: mergedModel!)
        
        var destModel = coordinator.managedObjectModel
        
        var compatible = destModel.isConfiguration(nil, compatibleWithStoreMetadata:sourceMetadata!)
        
        //add auto-migration to the options
        var optionsCopy:[NSObject:AnyObject]? = options
        if( optionsCopy == nil ) { optionsCopy = Dictionary() }
        optionsCopy![NSMigratePersistentStoresAutomaticallyOption] = true
        // this needs to be false
        optionsCopy![NSInferMappingModelAutomaticallyOption] = false

        
        if !compatible {
            var sourceModel = NSManagedObjectModel.mergedModelFromBundles(nil, forStoreMetadata:sourceMetadata!)
            var migrationManager:NSMigrationManager = NSMigrationManager(sourceModel:sourceModel!, destinationModel:destModel)
            println(migrationManager)
            
            
            var mappingModel = NSMappingModel(fromBundles:nil, forSourceModel:sourceModel, destinationModel:destModel)
            var worked = migrationManager.migrateStoreFromURL(storeURL!, type:storeType, options:optionsCopy, withMappingModel:mappingModel, toDestinationURL:storeURL!, destinationType:storeType, destinationOptions:nil, error:&error)
        }
        
      // Add Stores

        var store:NSPersistentStore? = coordinator.addPersistentStoreWithType(storeType, configuration: nil, URL: storeURL, options: optionsCopy, error: &error)
        
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
