//
//  Class.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 16/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//
import Realm

import Foundation
// Class model
class Class: RLMObject {
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
