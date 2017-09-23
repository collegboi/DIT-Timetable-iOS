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
        self.requestUpdate()
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
    
    func reloadComplications() {
        let server = CLKComplicationServer.sharedInstance()
        guard let complications = server.activeComplications, complications.count > 0 else {
            return
        }
        
        for complication in complications  {
            server.reloadTimeline(for: complication)
        }
    }
    
}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        if let objects = message["refresh"] as? [AnyObject] {
            let defaults = UserDefaults()
            defaults.set(objects, forKey: "todaytimetable")
            
            self.todayClasses = MyJSONMapper.toObjects(array: objects)

            // reload complication data
            reloadComplications()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        session.sendMessage(["update" : "now"],
                             replyHandler: { (response) in
                            
                            guard let array = response["update"] as? [AnyObject] else {
                                return
                            }
                                
                            let defaults = UserDefaults()
                            defaults.set(array, forKey: "todaytimetable")
                                
                            self.todayClasses = MyJSONMapper.toObjects(array: array)
                        },
                         errorHandler: { (error) in
                            print("Error sending message: %@", error)
                }
        )
        
    }
}
