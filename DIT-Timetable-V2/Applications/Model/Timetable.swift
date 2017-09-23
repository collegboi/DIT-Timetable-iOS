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
    var moduleCode: String = ""
    var moduleName: String = ""
    var name : String = "" {
        didSet {
            let moduleParts = name.components(separatedBy: " ")
            moduleName = name
            if(moduleParts.count >= 3 ) {
                
                moduleCode = moduleParts[moduleParts.count-2] + " " +   moduleParts[moduleParts.count-1]
                let moduleNameParts = name.components(separatedBy: moduleCode)
                if(moduleNameParts.count >= 2) {
                    moduleName = moduleNameParts[0]
                }
            }
        }
    }
    var lecture: String = ""
    var roomNo: String = ""
    var room : String = "" {
        didSet {
            var roomVal = ""
            let roomsParts = room.components(separatedBy: ",")
            if(roomsParts.count >= 2) {
                let roomNo = roomsParts[1]
                
                let roomNameParts = roomsParts[0].components(separatedBy: " ")
                for roomPart in roomNameParts {
                    roomVal += roomPart[0]
                }
                
                roomVal += " " + roomNo
                
            } else {
                roomVal = room
            }
            roomNo = roomVal
        }
    }
    var timeStartDate = Date()
    var timeEndDate = Date()
    var timeStart : String = "" {
        didSet {
            if timeStart.characters.count < 5 && !Utils.using12hClockFormat() {
                timeStart += "0"
            }
        }
    }
    var timeEnd : String = "" {
        didSet {
            if timeStart.characters.count < 5 && !Utils.using12hClockFormat() {
                timeEnd += "0"
            }
        }
    }
    var groups : String = ""
    var weeks : String = ""
    var notifOn : Int = 0
    var markDeleted : Bool = false
    
    init() {
    }
    
    init(dict: [String: AnyObject]) {
        
        id = dict.tryConvert(forKey: "id")
        dayNo = dict.tryConvert(forKey: "dayNo")
        name = dict.tryConvert(forKey: "name")
        lecture = dict.tryConvert(forKey: "lecture")
        room = dict.tryConvert(forKey: "room")
        roomNo = dict.tryConvert(forKey: "roomNo")
        timeStart = dict.tryConvert(forKey: "timeStart")
        timeEnd = dict.tryConvert(forKey: "timeEnd")
        moduleCode = dict.tryConvert(forKey: "moduleCode")
        moduleName = dict.tryConvert(forKey: "moduleName")
        groups = dict.tryConvert(forKey: "groups")
        weeks = dict.tryConvert(forKey: "weeks")
        notifOn = dict.tryConvert(forKey: "notifOn")
        
        let timetableParts = parseTimetable(module: name, room: room)
        moduleCode = timetableParts.code
        moduleName = timetableParts.name
        roomNo = timetableParts.room
    }
    
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
    
    func parseTimetable(module: String, room: String) -> (name: String, code: String, room: String) {
        
        var name: String = module
        var code: String = ""
        var roomVal: String = room
        
        let moduleParts = module.components(separatedBy: " ")
        
        if(moduleParts.count >= 3 ) {
            
            code = moduleParts[moduleParts.count-2] + " " +   moduleParts[moduleParts.count-1]
            let moduleNameParts = module.components(separatedBy: code)
            if(moduleNameParts.count >= 2) {
                name = moduleNameParts[0]
            }
        }
        
        let roomsParts = room.components(separatedBy: ",")
        if(roomsParts.count >= 2) {
            let roomNo = roomsParts[1]
            
            let roomNameParts = roomsParts[0].components(separatedBy: " ")
            for roomPart in roomNameParts {
                roomVal += roomPart[0]
            }
            
            roomVal += " " + roomNo
            
        } else {
            roomVal = room
        }
        
        return(name, code, roomVal)
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
    
    class func toJSON(timetables: [Timetable]) -> [AnyObject] {
        
        var timetablesObject = [AnyObject]()
        
        for dayTimetable in timetables {
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

