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
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        self.token = token
        self.getBuildValues()
        self.date = "12/12/2017 09:00:00"
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
