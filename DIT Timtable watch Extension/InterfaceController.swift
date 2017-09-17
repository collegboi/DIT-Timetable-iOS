//
//  InterfaceController.swift
//  DIT Timetable Extension
//
//  Created by Timothy Barnard on 16/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var classTableView: WKInterfaceTable!
    
    var todayClasses = [Timetable]() {
        didSet {
            OperationQueue.main.addOperation {
                self.reloadTable()
            }
        }
    }
    
    var session: WCSession?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.reloadTableData()
        self.requestUpdate()
    }
    
    func requestUpdate() {
        if WCSession.isSupported() {
            session = WCSession.default()
            session?.delegate = self
            session?.activate()
        }
    }
    
    func reloadTableData() {
        
        let database = Database()
    
        let today = Date()
        let day = today.weekday()
        let indexVal = (day+5) % 7
        self.todayClasses = database.getDayTimetable(dayNo: indexVal)
        self.reloadTable()
    }
    @IBAction func requestInfoButton() {
        self.requestUpdate()
    }
    
    func reloadTable() {
        
        self.classTableView.setNumberOfRows(self.todayClasses.count, withRowType: "timetableRow")
        
        for index in 0..<self.classTableView.numberOfRows {
            guard let controller = self.classTableView.rowController(at: index) as? ClassRowController else { continue }
            
            controller.timetable = self.todayClasses[index]
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let classSelected = self.todayClasses[rowIndex]
        presentController(withName: "ViewClass", context: classSelected)
    }
    
}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        print("Message: \(message)")
        
        if let dict = message["add"] as? [String: AnyObject] {
            
            let database = Database()
            let timetable = Timetable(dict: dict)
            let newClass = database.makeClass(timetable: timetable)
            database.saveClass(myClass: newClass)
        } else if let dict = message["edit"] as? [String: AnyObject] {
            
            let database = Database()
            let timetable = Timetable(dict: dict)
            let editClass = database.makeClass(timetable: timetable)
            database.editClass(myClass: editClass )
        } else {
            return
        }
        
        self.reloadTableData()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        /*session.sendMessage(["update" : "now"],
                             replyHandler: { (response) in
                            
                            guard let array = response["update"] as? [AnyObject] else {
                                return
                            }
                                
                            let database = Database()
                            database.removeAll()
                            
                            let timetables = MyJSONMapper.toObjects(array: array)
                            for timetable in timetables {
                                
                                let newClass = Class()
                                newClass.id = timetable.id
                                newClass.lecture = timetable.lecture
                                newClass.room = timetable.room
                                newClass.timeStart = timetable.timeStart
                                newClass.timeEnd = timetable.timeEnd
                                newClass.notifOn = timetable.notifOn
                                newClass.name = timetable.name
                                newClass.groups = timetable.groups
                                newClass.day = timetable.dayNo
                                
                                database.saveClass(myClass: newClass)
                            }

                            self.reloadTableData()
                        },
                         errorHandler: { (error) in
                            print("Error sending message: %@", error)
                }
        )*/
        
    }
}
