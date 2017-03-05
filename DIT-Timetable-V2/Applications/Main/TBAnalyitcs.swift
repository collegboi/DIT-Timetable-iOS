//
//  File.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation


enum SendType: String {
    case OpenApp = "OpenApp"
    case CloseApp = "CloseApp"
    case ViewOpen = "ViewOpen"
    case ViewClose = "ViewClose"
    case ButtonClick = "ButtonClick"
    case Generic = "Generic"
}

class TBAnalytics {
    
    class private var dateFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
    
    class private var nowDate: String {
        return self.dateFormatter.string(from: NSDate() as Date)
    }
    
    //MARK: - Internal methods
    class private func getTags() -> [String:AnyObject] {
        
        var tags = [String:AnyObject]()
        
        if tags["Build version"] == nil {
            
            if let buildVersion: AnyObject = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject?
            {
                tags["Build version"] = buildVersion as AnyObject?
                tags["Build name"] = RCFileManager.readPlistString(value: "CFBundleDisplayName") as AnyObject?
            }
        }
        
        #if os(iOS) || os(tvOS)
            if (tags["OS version"] == nil) {
                tags["OS version"] = UIDevice.current.systemVersion as AnyObject?
            }
            
            if (tags["Device make"] == nil) {
                tags["Device make"] = UIDevice.current.model as AnyObject?
            }
            tags["Device model name"] = UIDevice.current.modelName as AnyObject?
        #endif
        
        return tags
        
    }

    
    struct TBAnalytics: JSONSerializable {
        
        var timeStamp: String = ""
        var method: String = ""
        var className: String = ""
        var fileName: String = ""
        var configVersion: String = ""
        var type: String = ""
        var tags = [String:AnyObject]()
        
        init(dict: String) {}
        init() {}
        init(dict: [String]) {}
        init(dict: [String : Any]) {}
    }
    
    class func sendOpenApp(_ app: UIResponder , method: String? = #function , file: String? = #file) {
        self.sendData(String(describing: type(of: app)), file: file ?? "", method: method ?? "", type: .OpenApp )
    }
    
    class func sendOpenApp(_ view: UIView , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "", type: .OpenApp  )
    }
    
    class func sendCloseApp(_ app: UIResponder , method: String? = #function , file: String? = #file) {
        self.sendData(String(describing: type(of: app)), file: file ?? "", method: method ?? "", type: .CloseApp )
    }
    
    class func sendCloseApp(_ view: UIView , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "", type: .CloseApp )
    }
    
    class func sendButtonClick(_ view: UIView , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "", type: .ButtonClick )
    }
    
    
    class func sendButtonClick(_ view: UIViewController , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "", type: .ButtonClick)
    }
    
    class func sendViewOpen(_ view: UIView , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "", type: .ViewOpen )
    }
    
    
    class func sendViewOpen(_ view: UIViewController , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "", type: .ViewOpen)
    }
    
    class func sendViewClose(_ view: UIView , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "", type: .ViewClose )
    }

    class func sendViewClose(_ view: UIViewController , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "", type: .ViewClose)
    }
    
    class func send(_ app: UIResponder, type: SendType , method: String? = #function , file: String? = #file) {
        self.sendData(String(describing: type(of: app)), file: file ?? "", method: method ?? "", type: type )
    }
    
    class func send(_ view: UIView ,type: SendType, method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "", type: type )
    }
    
    
    class func send(_ view: UIViewController ,type: SendType , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "", type: type )
    }

    class func send(_ app: UIResponder , method: String? = #function , file: String? = #file) {
        self.sendData(String(describing: type(of: app)), file: file ?? "", method: method ?? "" )
    }
    
    class func send(_ view: UIView , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "" )
    }
    
    
    class func send(_ view: UIViewController , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "" )
    }
    
    private class func sendData(_ className: String, file:String, method:String, type: SendType = .Generic ) {
        
        let doAnalytics = UserDefaults.standard.value(forKey: "doAnalytics") as? String ?? "0"
        
        if doAnalytics == "1" {
         
            let version = UserDefaults.standard.value(forKey: "version") as? String
            
            var newAnalytics = TBAnalytics()
            newAnalytics.className = className
            newAnalytics.fileName = file
            newAnalytics.method = method
            newAnalytics.timeStamp = self.nowDate
            newAnalytics.configVersion = version ?? "0.0"
            newAnalytics.tags = self.getTags()
            newAnalytics.type = type.rawValue
            self.sendUserAnalytics(newAnalytics)
        }
    }
    
    
    class private func sendUserAnalytics(_ tbAnalytics: TBAnalytics) {
        
        tbAnalytics.sendInBackground("") { (completed, data) in
            
            DispatchQueue.main.async {
                if (completed) {
                    print("sent")
                } else {
                    print("error")
                }
            }

        }
    
    }
    
}
