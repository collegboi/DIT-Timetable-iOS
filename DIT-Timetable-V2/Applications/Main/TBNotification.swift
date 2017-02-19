//
//  TBNotification.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 06/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

class TBNotification {
    
    private var deviceID: String = ""
    private var message: String = ""
    private var userID: String = ""
    
    init(){}
    
    func setDeviceID(_ deviceID:String) {
        self.deviceID = deviceID
    }
    func setMessage(_ message:String) {
        self.message = message
    }
    func setUserID(_ userID:String) {
        self.userID = userID
    }
    
    func sendNotification(_ appKey: String = "", notificationCompleted : @escaping (_ succeeded: Bool, _ data: String) -> ()) {
        
        var url: String = ""
        url = url.readPlistString(value: "URL", "http://0.0.0.0:8181")
        
        var key: String = ""
        
        if appKey != "" {
            key = appKey
        } else {
            key = key.readPlistString(value: "APPKEY", "")
        }
        
        let apiEndpoint = "/api/" + key
        
        let networkURL =  url + apiEndpoint + "/notification/" //"http://Timothys-MacBook-Pro.local:8181/notification/"
        
        if (self.deviceID == "" && self.message == "") || (self.userID == "" && self.message == "") {
            notificationCompleted(false, "values not set")
            return
        }
        
        guard let endpoint = NSURL(string: networkURL) else {
            print("Error creating endpoint")
            notificationCompleted(false, "url incorrect")
            return
        }
        let request = NSMutableURLRequest(url: endpoint as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let dict : [String:AnyObject] = [
            "deviceId":self.deviceID as AnyObject,
            "message":self.message as AnyObject
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: [])
        } catch {
            //err = error
            request.httpBody = nil
        }
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            
            if ((error) != nil) {
                print(error!.localizedDescription)
                notificationCompleted(false, "not sent")
            } else {
                notificationCompleted(true, "sent")
            }
        })
        task.resume()
        
    }
}


extension String {
    
    func readPlistString( value: String, _ defaultStr: String = "") -> String {
        var defaultURL = defaultStr
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            guard let valueStr = dict[value] as? String else {
                return defaultURL
            }
            
            defaultURL = valueStr
        }
        return defaultURL
    }
}
