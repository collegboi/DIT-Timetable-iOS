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
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var day = 0
    @objc dynamic var lecture = ""
    @objc dynamic var room = ""
    @objc dynamic var timeStart = ""
    @objc dynamic var timeEnd = ""
    @objc dynamic var groups = ""
    @objc dynamic var weeks = ""
    @objc dynamic var notifOn = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
