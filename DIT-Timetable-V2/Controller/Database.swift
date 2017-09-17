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
        
        print(realmPath?.absoluteString)
        self.realm = try! RLMRealm(configuration: realmConfig)
        RLMRealmConfiguration.setDefault(realmConfig)
    }
    
    @discardableResult
    func saveClass( myClass : Class ) -> Int {
        
        myClass.id = self.getNextPrimaryKeyID()
        
        if let realm = realm {
        
            realm.beginWriteTransaction()
        
            realm.add(myClass)
            do {
                try realm.commitWriteTransaction()
            } catch {
                print("not commiting transaction")
            }
            
            return myClass.id
            
        } else {
            return -1
        }
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
    
    func deleteClass( classID : Int ) {
        
        /*let filterString = "id="+String(classID)
        
        var dataSource: RLMResults = Class.allObjects()
        
        let updateClass = self.realm?.objects(Class.self).filter(filterString)
        
        try! self.realm?.write {
            self.realm?.delete(updateClass!)
        }*/
    }
    
    func getClass( classID : Int) -> Class {
        
        /*let filterString = "id="+String(classID)
        
        let returnClasses = self.realm?.objects(Class.self).filter(filterString)
        
        if (returnClasses?.count)! > 0 {
            return returnClasses![0]
        } else {
            return Class()
        }*/
        
        return Class()
    }
    
    func getSavedClassesCount() -> Int  {
        
        let results: RLMResults = Class.allObjects()
        return Int(results.count)
    }
    
    func editClass( myClass: Class ) {
        /*try! self.realm?.write {
            self.realm?.add(myClass, update: true)
        }*/
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
    
    func getDayTimetable( dayNo : Int ) ->[Timetable] {
        var dayTimetable = [Timetable]()
        
        //let filterString = "day="+String(dayNo)
        
        let predicate = NSPredicate(format: "day = %d", dayNo)
        
        guard let realm = self.realm else {
            return [Timetable]()
        }
        
        let dataSource: RLMResults = Class.allObjects(in: realm).sortedResults(usingKeyPath: "timeStart", ascending: true)
        
        for index in 0..<Int(dataSource.count) {
            let curClass = dataSource[UInt(index)] as! Class
                
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
            
            dayTimetable.append(newClass)
        }
        
        return dayTimetable
    }

    func getDayTimetableAfterNow( dayNo : Int ) ->[Timetable] {
        var dayTimetable = [Timetable]()
        
        let predicate = NSPredicate(format: "day=", dayNo)
        
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
                
                dayTimetable.append(newClass)
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
            
            allTimetables[curClass.day].timetable.append(newClass)
            
        }
        
        return allTimetables
    }
}
