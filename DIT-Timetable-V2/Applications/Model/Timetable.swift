//
//  Timetable.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 16/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.

import Foundation

class Timetable {
    var id : Int = 0
    var dayNo : Int = 0
    var name : String = ""
    var lecture: String = ""
    var room : String = ""
    var timeStart : String = ""
    var timeEnd : String = ""
    var groups : String = ""
    var weeks : String = ""
    var notifOn : Int = 0
    var markDeleted : Bool = false
    
    
    func toJSON() -> [String: AnyObject] {
        var dict : [String: AnyObject] = [:]
        dict["id"] = (self.id) as AnyObject
        dict["dayNo"] = (self.dayNo) as AnyObject
        dict["name"] = (self.name) as AnyObject
        dict["lecture"] = (self.lecture) as AnyObject
        dict["room"] = (self.room) as AnyObject
        dict["timeStart"] = (self.timeStart) as AnyObject
        dict["timeEnd"] = (self.timeEnd) as AnyObject
        dict["groups"] = (self.groups) as AnyObject
        dict["weeks"] = (self.weeks) as AnyObject
        dict["notifOn"] = (self.notifOn) as AnyObject
        return dict
    }
}

class AllTimetables {
    
    var timetable = [Timetable]()
    
    func toJSON() -> [AnyObject] {
        
        var timetablesObject = [AnyObject]()
        
        for dayTimetable in timetable {
            var dict : [String: AnyObject] = [:]
            
            dict["id"] = (dayTimetable.id) as AnyObject
            dict["dayNo"] = (dayTimetable.dayNo) as AnyObject
            dict["name"] = (dayTimetable.name) as AnyObject
            dict["lecture"] = (dayTimetable.lecture) as AnyObject
            dict["room"] = (dayTimetable.room) as AnyObject
            dict["timeStart"] = (dayTimetable.timeStart) as AnyObject
            dict["timeEnd"] = (dayTimetable.timeEnd) as AnyObject
            dict["groups"] = (dayTimetable.groups) as AnyObject
            dict["weeks"] = (dayTimetable.weeks) as AnyObject
            dict["notifOn"] = (dayTimetable.notifOn) as AnyObject
            
            timetablesObject.append(dict as AnyObject)
        }
        return timetablesObject
    }
}

class MyJSONMapper {
    
    class func toJSON(timetables: [AllTimetables]) -> [AnyObject] {
        
        var timetablesObject = [AnyObject]()
        
        for timetable in timetables {
        
            for dayTimetable in timetable.timetable {
                var dict : [String: AnyObject] = [:]
                
                dict["id"] = (dayTimetable.id) as AnyObject
                dict["dayNo"] = (dayTimetable.dayNo) as AnyObject
                dict["name"] = (dayTimetable.name) as AnyObject
                dict["lecture"] = (dayTimetable.lecture) as AnyObject
                dict["room"] = (dayTimetable.room) as AnyObject
                dict["timeStart"] = (dayTimetable.timeStart) as AnyObject
                dict["timeEnd"] = (dayTimetable.timeEnd) as AnyObject
                dict["groups"] = (dayTimetable.groups) as AnyObject
                dict["weeks"] = (dayTimetable.weeks) as AnyObject
                dict["notifOn"] = (dayTimetable.notifOn) as AnyObject
                
                timetablesObject.append(dict as AnyObject)
            }
        }
        return timetablesObject
        
        /*do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: timetablesObject, options: .prettyPrinted) as Data
            return String(data: jsonData, encoding: String.Encoding.utf8)!
            
        } catch {
            return ""
        }*/
    }
    
    class func toObjects(array: [AnyObject] ) -> [Timetable] {
        
        var timestables = [Timetable]()
        
        for object in array {
            
            guard let dict = object as? [String: AnyObject] else {
                continue
            }
            
            let newTimetable = Timetable()
            
            newTimetable.id = dict.tryConvert(forKey: "id")
            newTimetable.dayNo = dict.tryConvert(forKey: "dayNo")
            newTimetable.name = dict.tryConvert(forKey: "name")
            newTimetable.lecture = dict.tryConvert(forKey: "lecture")
            newTimetable.room = dict.tryConvert(forKey: "room")
            newTimetable.timeStart = dict.tryConvert(forKey: "timeStart")
            newTimetable.timeEnd = dict.tryConvert(forKey: "timeEnd")
            newTimetable.groups = dict.tryConvert(forKey: "groups")
            newTimetable.weeks = dict.tryConvert(forKey: "weeks")
            newTimetable.notifOn = dict.tryConvert(forKey: "notifOn")

            timestables.append(newTimetable)
            
        }
        
        return timestables
    }
}

