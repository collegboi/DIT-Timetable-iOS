//
//  Database.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 18/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation
import Realm

class Database {
    
    var backgroundQueue: DispatchQueue?
    
    var realm : RLMRealm?
    
    init() {
        
        let directory: NSURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.barnard.dit-timetable.today")! as NSURL
        let realmPath = directory.appendingPathComponent("default.realm")
        let realmConfig = RLMRealmConfiguration.default()
        realmConfig.fileURL = realmPath
        realmConfig.schemaVersion = 3
        realmConfig.migrationBlock = { migration, oldSchemaVersion in
            if (oldSchemaVersion < 3) {
                
            }
        }
        
        self.realm = try! RLMRealm(configuration: realmConfig)
        RLMRealmConfiguration.setDefault(realmConfig)
    }
    
    private func createNewRealmInstance() -> RLMRealm? {
        
        let directory: NSURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.barnard.dit-timetable.today")! as NSURL
        let realmPath = directory.appendingPathComponent("default.realm")
        let realmConfig = RLMRealmConfiguration.default()
        realmConfig.fileURL = realmPath
        realmConfig.schemaVersion = 3
        realmConfig.migrationBlock = { migration, oldSchemaVersion in
            if (oldSchemaVersion < 3) {
                
            }
        }
    
        return  try! RLMRealm(configuration: realmConfig)
    }
    
    @discardableResult
    func saveClass( myClass : Class ) -> Int {
        
        if(myClass.id == -1 ) {
            myClass.id = self.getNextPrimaryKeyID()
        }
            
        if let realm = self.createNewRealmInstance() {
        
            realm.beginWriteTransaction()
        
            realm.add(myClass)
            do {
                try realm.commitWriteTransaction()
            } catch {
                print("not commiting transaction")
            }
        }
        return myClass.id
    }
    
    func removeAll() {
        if let realm = realm {
            realm.beginWriteTransaction()
            realm.deleteAllObjects()
            try! realm.commitWriteTransaction()
        }
    }

    
    func updateTimetable( timetable : Timetable) {
        
        let updateClass = Class()
        updateClass.id = timetable.id
        updateClass.lecture = timetable.lecture
        updateClass.room = timetable.room
        updateClass.timeStart = timetable.timeStart
        updateClass.timeEnd = timetable.timeEnd
        updateClass.notifOn = timetable.notifOn
        updateClass.name = timetable.name
        updateClass.groups = timetable.groups
        updateClass.day = timetable.dayNo
        
        self.editClass( myClass: updateClass)
    }
    
    func makeClass( timetable : Timetable) -> Class {
        
        let updateClass = Class()
        updateClass.id = timetable.id
        updateClass.lecture = timetable.lecture
        updateClass.room = timetable.room
        updateClass.timeStart = timetable.timeStart
        updateClass.timeEnd = timetable.timeEnd
        updateClass.notifOn = timetable.notifOn
        updateClass.name = timetable.name
        updateClass.groups = timetable.groups
        updateClass.day = timetable.dayNo
        
        return updateClass
    }

    
    func deleteClass( classID : Int ) {
        
        let predicate = NSPredicate(format: "id = %d", classID)
        
        guard let realm = self.createNewRealmInstance() else {
            return
        }
        
        let dataSource: RLMResults = Class.objects(in: realm, with: predicate)
        
        if(Int(dataSource.count) > 0) {
            guard let deleteClass = dataSource[UInt(0)] as? Class else {
                return
            }
            if(realm.inWriteTransaction) {
                realm.cancelWriteTransaction()
            }
            
            realm.beginWriteTransaction()
            
            realm.delete(deleteClass)
            do {
                try realm.commitWriteTransaction()
            } catch {
                print("edit: not commiting transaction")
            }

        }
    }
    
    func getClass( classID : Int) -> Class {
        
        let predicate = NSPredicate(format: "id = %d", classID)
        
        guard let realm = self.createNewRealmInstance() else {
            return Class()
        }
        
        let dataSource: RLMResults = Class.objects(in: realm, with: predicate)
        
        if(Int(dataSource.count) > 0) {
            guard let curClass = dataSource[UInt(0)] as? Class else {
                return Class()
            }
            return curClass
        } else {
            return Class()
        }
    }
    
    func getSavedClassesCount() -> Int  {
        
        let results: RLMResults = Class.allObjects()
        return Int(results.count)
    }
    
    func editClass( myClass: Class ) {
        
        if let realm = self.createNewRealmInstance() {
            
            if(realm.inWriteTransaction) {
                realm.cancelWriteTransaction()
            }
            
            realm.beginWriteTransaction()
            
            realm.addOrUpdate(myClass)
            do {
                try realm.commitWriteTransaction()
            } catch {
                print("edit: not commiting transaction")
            }
        }
    }
    
    func getNextPrimaryKeyID() -> Int {
        
        var id = 0
        
        guard let realm = self.realm else {
            return id
        }
        
        let dataSource: RLMResults = Class.allObjects(in: realm).sortedResults(usingKeyPath: "id", ascending: true)
        
        if (dataSource.count) > 0 {
            let curClass = dataSource[(dataSource.count)-1] as! Class
            id = curClass.id
        }
        return id + 1
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
    
    func makeTimetablFormClass(curClass: Class) -> Timetable {
        
        let newClass = Timetable()
        newClass.id = curClass.id
        newClass.lecture = curClass.lecture
        newClass.timeStart = curClass.timeStart
        newClass.timeEnd = curClass.timeEnd
        newClass.dayNo = curClass.day
        newClass.name = curClass.name
        newClass.groups = curClass.groups
        newClass.room = curClass.room
        newClass.notifOn = curClass.notifOn
        
        newClass.timeStartDate = newClass.timeStart.convertToDate()
        newClass.timeEndDate = newClass.timeEnd.convertToDate()
        
        let timetableParts = parseTimetable(module: newClass.name, room: newClass.room)
        newClass.moduleCode = timetableParts.code
        newClass.moduleName = timetableParts.name
        newClass.roomNo = timetableParts.room
        
        return newClass
    }
    
    func getDayTimetable( dayNo : Int ) ->[Timetable] {
        var dayTimetable = [Timetable]()
        
        let predicate = NSPredicate(format: "day = %d", dayNo)
        
        guard let realm = self.realm else {
            return [Timetable]()
        }
        
        let dataSource: RLMResults = Class.objects(in: realm, with: predicate).sortedResults(usingKeyPath: "timeStart", ascending: true)
        
        for index in 0..<Int(dataSource.count) {
            let curClass = dataSource[UInt(index)] as! Class
            
            let timetable = self.makeTimetablFormClass(curClass: curClass)
            
            dayTimetable.append(timetable)
        }
        
        return dayTimetable
    }
    
    func getClassNow() -> Timetable? {
        
        let today = Date()
        let day = today.weekday()
        let indexVal = (day+5) % 7
        
        let predicate = NSPredicate(format: "day = %d", indexVal)
        
        guard let realm = self.realm else {
            return nil
        }
        
        let dataSource: RLMResults = Class.objects(in: realm, with: predicate).sortedResults(usingKeyPath: "timeStart", ascending: true)
        
        for index in 0..<Int(dataSource.count) {
            let curClass = dataSource[UInt(index)] as! Class
            
            let timetable = self.makeTimetablFormClass(curClass: curClass)
            let startHour = timetable.timeStartDate.hour()
            let endHour = timetable.timeEndDate.hour()
            let nowHour = today.hour()
            
            if(nowHour >= startHour && nowHour <= endHour ) {
                return timetable
            }
        }
        
        return nil
    }

    func getDayTimetableAfterNow( dayNo : Int ) ->[Timetable] {
        var dayTimetable = [Timetable]()
        
        let predicate = NSPredicate(format: "day = %d", dayNo)
        
        guard let realm = self.realm else {
            return [Timetable]()
        }
        
        let dataSource: RLMResults = Class.objects(in: realm, with: predicate).sortedResults(usingKeyPath: "timeStart", ascending: true)
        
        for index in 0..<Int(dataSource.count) {
            let curClass = dataSource[UInt(index)] as! Class
            
            let nowTime = Date()
            let hour = nowTime.hour()
            let classTimeParts = curClass.timeStart.components(separatedBy: ":")
            let classTimeEndParts = curClass.timeEnd.components(separatedBy: ":")
            
            guard let classTimeHr = Int(classTimeParts[0]) else {
                continue
            }
            
            guard let classTimeEndHr = Int(classTimeEndParts[0]) else {
                continue
            }
            
            if(classTimeHr >= hour || classTimeEndHr < hour ) {
                
                let timetable = self.makeTimetablFormClass(curClass: curClass)
                
                dayTimetable.append(timetable)
            }
        }
        
        return dayTimetable
    }

    
    
    func getAllTimetables() -> [AllTimetables] {
        
        var allTimetables = [AllTimetables]()
        
        guard let realm = self.realm else {
            return [AllTimetables]()
        }
        
        for _ in 1...7 {
            let newTimetable = AllTimetables()
            allTimetables.append(newTimetable)
        }
        
        let dataSource = Class.allObjects(in: realm).sortedResults(usingKeyPath: "timeStart", ascending: true)
        
        for index in 0..<Int(dataSource.count) {
            let curClass = dataSource[UInt(index)] as! Class
            
            let timetable = self.makeTimetablFormClass(curClass: curClass)
            
            allTimetables[curClass.day].timetable.append(timetable)
            
        }
        
        return allTimetables
    }
}
