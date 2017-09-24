//
//  MySessionGroup.swift
//  DIT Timtable watch Extension
//
//  Created by Timothy Barnard on 23/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import WatchConnectivity

protocol SessionDataDelegate {
    func sendTimetableBack(timetables: [Timetable])
}

class SessionManager: NSObject {
    
    var session: WCSession?
    var sessionDataDelegate: SessionDataDelegate?
    
    override init() {
        super.init()
    }
    
    private func update() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func requestUpdate() {
        update()
    }
    
}
extension SessionManager: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Message: \(message)")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        session.sendMessage(["update" : "now"],
                            replyHandler: { (response) in
                                
                                guard let array = response["update"] as? [AnyObject] else {
                                    return
                                }
                                let timetables = MyJSONMapper.toObjects(array: array)
                                self.sessionDataDelegate?.sendTimetableBack(timetables: timetables)
        },
                            errorHandler: { (error) in
                                print("Error sending message: %@", error)
        }
        )
        
    }
}
