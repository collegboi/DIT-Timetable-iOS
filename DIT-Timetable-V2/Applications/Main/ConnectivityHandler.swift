//
//  ConnectivityHandler.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 16/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import WatchConnectivity

class ConnectivityHandler : NSObject, WCSessionDelegate {
    
    var session = WCSession.default
    
    var database: Database?
    
    override init() {
        super.init()
        
        session.delegate = self
        session.activate()
        
        NSLog("%@", "Paired Watch: \(session.isPaired), Watch App Installed: \(session.isWatchAppInstalled)")
    }
    
    func setupDatabase(database: Database) {
        self.database = database
    }
    
    // MARK: - WCSessionDelegate
    
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("%@", "activationDidCompleteWith activationState:\(activationState) error:\(error)")
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        NSLog("%@", "sessionDidBecomeInactive: \(session)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        NSLog("%@", "sessionDidDeactivate: \(session)")
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        NSLog("%@", "sessionWatchStateDidChange: \(session)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        NSLog("didReceiveMessage: %@", message)
        if message["update"] as? String == "now" {
            
           if let database = self.database  {
            
                let today = Date()
                let day = today.weekday()
                let indexVal = (day+5) % 7
            
                DispatchQueue.main.async {
                    let timetables = database.getDayTimetable(dayNo: indexVal)
                    let timetableObjects = MyJSONMapper.toJSON(timetables: timetables)
                    
                    replyHandler(["update" : timetableObjects])
                }
                
            } else {
                replyHandler(["error" : "unable to update"])
            }
        }
    }
    
}
