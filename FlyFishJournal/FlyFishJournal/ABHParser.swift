//
//  ABHParser.swift
//  FlyFishJournal
//
//  Created by hollarab on 11/4/14.
//  Copyright (c) 2014 a. brooks hollar. All rights reserved.
//

import Foundation
import CoreData

class ABHParser: NSObject {
    
    class func parseEntriesFrom(path:String, intoMOC moc:NSManagedObjectContext?) -> [ABHEntry]? {
        println("parsing entries from: \(path)")
        var entries:[ABHEntry] = []
        
        let dataOp:NSData? = NSData(contentsOfFile:path)
        if let data = dataOp {
            
            var error:NSError? = nil
            let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error:&error) as Dictionary<String, AnyObject>
            println(jsonResult)
            if error == nil {
                let entriesOpt = jsonResult["entries"] as? [Dictionary<String,AnyObject>]
                if( entriesOpt != nil ){
                    println("found \(entriesOpt!.count) entries")
                    for entryDic in entriesOpt! {
                        if let entry = entryFrom(entryDic, intoMOC:moc!) {
                            entries.append(entry)
                        }
                    }
                } else {
                    println("found no enties")
                }
            } else {
                println("JSON PARSE ERROR\n\(error)")
                exit(1)
            }
        } else {
            println("no or non-json file at '\(path)'")
        }
        
        return entries
    }
    
    class func entryFrom(dic:Dictionary<String,AnyObject>, intoMOC moc:NSManagedObjectContext) -> ABHEntry? {
        
        // this isn't working, so have to use KVC for now
        // var entry = ABHEntry.newInstanceInManagedObjectContext(moc) as ABHEntry
        
        var entity = ABHEntry.entityInManagedObjectContext(moc)
        var entry = NSEntityDescription.insertNewObjectForEntityForName(entity!.name!, inManagedObjectContext: moc) as NSManagedObject
        
        println( entity == entry.entity )
        
        if let title:AnyObject = dic["title"] {
            entry.setValue(title, forKeyPath:"title")
        }
        
        if let text:AnyObject = dic["text"] {
            entry.setValue(text, forKeyPath:"text")
        }
        
        if let rating:AnyObject = dic["rating"] {
            let ii = rating as NSNumber
            entry.setValue(ii, forKeyPath:"rating")
        }
        
        if let timestamp:AnyObject = dic["timestamp"] {
            var ii = (timestamp as NSNumber).doubleValue
            entry.setValue(NSDate(timeIntervalSince1970:ii), forKeyPath:"timeStamp")
        }
        
        return nil
    }
}
