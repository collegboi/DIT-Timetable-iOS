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

class TBAnalyitcs {
    
    class private var dateFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
    
    class private var nowDate: String {
        return self.dateFormatter.string(from: NSDate() as Date)
    }
    
    struct TBAnalyitcs: JSONSerializable {
        
        var timeStamp: String = ""
        var method: String = ""
        var className: String = ""
        var fileName: String = ""
        var configVersion: String = ""
        var type: String = ""
        
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
        let version = UserDefaults.standard.value(forKey: "version") as? String
        
        var newAnalytics = TBAnalyitcs()
        newAnalytics.className = className
        newAnalytics.fileName = file
        newAnalytics.method = method
        newAnalytics.timeStamp = self.nowDate
        newAnalytics.configVersion = version ?? "1.2"
        newAnalytics.type = type.rawValue
        self.sendUserAnalytics(newAnalytics)
    }
    
    
    class private func sendUserAnalytics(_ tbAnalyitcs: TBAnalyitcs) {
        
        tbAnalyitcs.sendInBackground("") { (completed, data) in
            
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
