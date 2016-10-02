//
//  Timetable.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 16/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//
import RealmSwift

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
}

class AllTimetables {
    
    var timetable = [Timetable]()
}
// Class model
class Class: Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var day = 0
    dynamic var lecture = ""
    dynamic var room = ""
    dynamic var timeStart = ""
    dynamic var timeEnd = ""
    dynamic var groups = ""
    dynamic var weeks = ""
    dynamic var notifOn = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
