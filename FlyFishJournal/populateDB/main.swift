//
//  main.swift
//  populateDB
//
//  Created by hollarab on 11/4/14.
//  Copyright (c) 2014 LameSauce Software. All rights reserved.
//

/**
NOTE: you may have to "Edit Scheme" and add or edit command line arguments to journalPop target.  In order:

$SRCROOT/default.json
$SRCROOT/cli_db.sqlite
$SRCROOT/FlyFishJournal.momd

**/

import Foundation

// not used, but cool!
func input() -> String {
    var keyboard = NSFileHandle.fileHandleWithStandardInput()
    var inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding)!
}

var args:[String] = Process.arguments
let path = args.removeAtIndex(0)
println("Booted from: \(path)")

var filename = "", sqlString = "", modelString = ""

if ( args.count == 3 ) {
    filename = args[0]
    sqlString = args[1]
    modelString = args[2]
    
    if !sqlString.hasPrefix("file:") {
        sqlString = "file:" + sqlString
    }
} else {
    println("usage: 'journalPop JSON_DATA_FILE SQL_DB_FILE MOMD_FILE' with FULL PATHS!")
    exit(1)
}

let url = NSURL(string:sqlString)
let modelURL = NSURL(string:modelString)
var moc = ABHManagedObjectContext.createAt(url, modelURL:modelURL, options: nil)

let entries = ABHEntry.allInstancesInManagedObjectContext(moc)

if entries == nil || entries!.count == 0 {
    ABHParser.parseEntriesFrom(filename, intoMOC: moc)
    var error:NSError? = nil
    moc.save(&error)
    if error == nil {
        println("SAVED!")
    } else {
        println(error)
    }
} else {
    println("Entries already loading.  Skipped data import")
}

let entriesOpt = ABHEntry.allInstancesInManagedObjectContext(moc)
if let entries = entriesOpt {
    println("Found \(entries.count) in dB")
    var line = 1
    for entry in entries {
        
        var string = "\(line)) "
        
        if let obj:AnyObject = entry.valueForKeyPath("title") {
            string += obj as String
        }
        if let obj:AnyObject = entry.valueForKeyPath("rating") {
            let num = (obj as NSNumber).integerValue
            string += " (\(num))"
        }
        if let obj:AnyObject = entry.valueForKeyPath("text") {
            string += " \(obj as String)"
        }
        if let obj:AnyObject = entry.valueForKeyPath("timeStamp") {
            string += " \(obj)"
        }
        
        println(string)
        line++
    }
} else {
    println("no entries loaded")
}

