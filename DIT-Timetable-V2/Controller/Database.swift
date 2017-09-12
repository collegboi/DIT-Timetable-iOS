//
//  Database.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 18/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    
    var realm : Realm?
    
    init() {
        self.realm = try! Realm()
    }
    
    func saveClass( myClass : Class ) {
        
        myClass.id = self.getNextPrimaryKeyID()
        
        try! realm?.write {
            self.realm?.add(myClass)
        }
    }
    
    func backgroundAdd() {
        // Import many items in a background thread
        DispatchQueue.global().async {
            // Get new realm and table since we are in a new thread
            let realm = try! Realm()
            realm.beginWrite()
            for _ in 0..<5 {
                // Add row via dictionary. Order is ignored.
                
            }
            try! realm.commitWrite()
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
        
        let filterString = "id="+String(classID)
        
        let updateClass = self.realm?.objects(Class.self).filter(filterString)
        
        try! self.realm?.write {
            self.realm?.delete(updateClass!)
        }
    }
    
    func getClass( classID : Int) -> Class {
        
        let filterString = "id="+String(classID)
        
        let returnClasses = self.realm?.objects(Class.self).filter(filterString)
        
        if (returnClasses?.count)! > 0 {
            return returnClasses![0]
        } else {
            return Class()
        }
        
    }
    
    func getSavedClassesCount() -> Int  {
        
        let myClasses = self.realm?.objects(Class.self)
        
        return myClasses!.count
    }
    
    func editClass( myClass: Class ) {
        try! self.realm?.write {
            self.realm?.add(myClass, update: true)
        }
    }
    
    func getNextPrimaryKeyID() -> Int {
        
        var id = 0
        
        let myClasses = self.realm?.objects(Class.self).sorted(byKeyPath: "id")
        
        if (myClasses?.count)! > 0 {
            id = (myClasses?[(myClasses?.count)!-1].id)! + 1
        }
        return id

    }
    
    func getDayTimetable( dayNo : Int ) ->[Timetable] {
        var dayTimetable = [Timetable]()
        
        let filterString = "day="+String(dayNo)
        
        let myClasses = self.realm?.objects(Class.self).filter(filterString).sorted(byKeyPath: "timeStart")
        
        for curClass in myClasses! {
            
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
    
    func getAllTimetables() -> [AllTimetables] {
        
        var allTimetables = [AllTimetables]()
        
        for _ in 1...7 {
            let newTimetable = AllTimetables()
            allTimetables.append(newTimetable)
        }
        
        let myClasses = self.realm?.objects(Class.self).sorted(byKeyPath: "timeStart")
        
        for curClass in myClasses! {
            
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
