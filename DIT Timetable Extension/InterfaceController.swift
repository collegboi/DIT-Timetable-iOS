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
    
    var database: Database?
    
    var session: WCSession?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        //database = Database()
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
        guard let database = self.database else {
            return
        }
        
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
        
        DispatchQueue.main.async {
            
            self.classTableView.setNumberOfRows(self.todayClasses.count, withRowType: "timetableRow")
            
            for index in 0..<self.classTableView.numberOfRows {
                guard let controller = self.classTableView.rowController(at: index) as? ClassRowController else { continue }
                
                controller.timetable = self.todayClasses[index]
            }
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
        let msg = message["msg"]!
        print("Message: \(msg)")
        
        /*let timetable = Timetable()
        timetable.dayNo = 0
        timetable.name = msg as! String
        timetable.timeStart = "10:00"
        timetable.timeEnd = "11:00"
        self.todayClasses.append(timetable)*/
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        session.sendMessage(["update" : "now"],
                             replyHandler: { (response) in
                            
                                print(response)
                                guard let array = response["update"] as? [AnyObject] else {
                                    return
                                }
                                
                                let timestables = MyJSONMapper.toObjects(array: array)
                                self.todayClasses = timestables
        },
                             errorHandler: { (error) in
                                print("Error sending message: %@", error)
        }
        )
        
    }
}
