//
//  InstallationObj.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 06/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

struct Installation: JSONSerializable {
  
    private var date:String!
    private var token:String!
    private var buildVersion:String!
    private var buildName:String!
    private var OSVersion:String!
    private var deviceModel:String!
    
    init(deviceToken:Data) {
        let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        self.token = token
        self.getBuildValues()
        self.date = TBTime.nowDateTime()
    }
    
    init() {}
    
    init(dict: String) {}
    
    init(dict: [String]) {}
    
    init(dict: [String : Any]) {}
    
    //MARK: - Internal methods
    internal mutating func getBuildValues() {
        
        self.buildVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        self.buildName = RCFileManager.readPlistString(value: "CFBundleDisplayName")
        
        #if os(iOS) || os(tvOS)
        self.OSVersion = UIDevice.current.systemVersion as String
        self.deviceModel = UIDevice.current.model as String
        #endif
    }
}

class TBTime {
    
    static func nowDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        return dateFormatter.string(from: Date())
    }
}
