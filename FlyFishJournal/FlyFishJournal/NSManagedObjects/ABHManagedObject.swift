//
//  ABHManagedObject.swift
//  FlyFishJournal
//
//  Created by hollarab on 10/27/14.
//  Copyright (c) 2014 a. brooks hollar. All rights reserved.
//

import UIKit
import CoreData

class ABHManagedObject: NSManagedObject {

    //MARK: - MUST Overirde in subclass
    class var entityName:String {
        assertionFailure("you must override 'class var entityName:String' in sub-class")
    }

    class func sortDescriptors() -> [AnyObject]? {
        assertionFailure("you must override 'class func sortDescriptors -> [AnyObject]?' in sub-class")
    }
    
    //MARK: - COULD Overirde in subclass
    class func fetchRequest() -> NSFetchRequest {
        var fetch = NSFetchRequest(entityName: entityName)
        return fetch
    }
    
    class func sortedFetchRequest() -> NSFetchRequest {
        var fetch = fetchRequest()
        fetch.sortDescriptors = sortDescriptors()
        return fetch
    }
    
    //MARK: - Generic helpers for sub-classes
    class func newInstanceInManagedObjectContext(context:NSManagedObjectContext) -> NSManagedObject {
        // will this down-cast and mess things up?
        let object:NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: context) as NSManagedObject
        return object
    }

    class func entityInManagedObjectContext(context:NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entityForName(entityName, inManagedObjectContext:context)
    }

    class func allInstancesWithPredicate(predicate:NSPredicate?, inManagedObjectContext context:NSManagedObjectContext) -> [AnyObject]? {
        let fetchRequst = fetchRequest()
        fetchRequst.predicate = predicate
        var error:NSError? = nil
        let results:[AnyObject]? = context.executeFetchRequest(fetchRequst, error: &error)
        if results != nil {
            return results
        } else {
            println("fetch error \(error) \(error?.userInfo)")
            return []
        }
    }
    
    class func allInstancesInManagedObjectContext(context:NSManagedObjectContext) -> [AnyObject]? {
        let results = allInstancesWithPredicate(nil, inManagedObjectContext: context)
        return results
    }
}
