//
//  File.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 08/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

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
        
        init(dict: String) {}
        init() {}
        init(dict: [String]) {}
        init(dict: [String : Any]) {}
    }

    class func send(_ app: UIResponder , method: String? = #function , file: String? = #file) {
        self.sendData(String(describing: type(of: app)), file: file ?? "", method: method ?? "" )
    }
    
    class func send(_ view: UIView , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "" )
    }
    
    
    class func send( view: UIViewController , method: String? = #function , file: String? = #file){
        self.sendData(String(describing: type(of: view)), file: file ?? "", method: method ?? "" )
    }
    
    private class func sendData(_ className: String, file:String, method:String ) {
        var newAnalytics = TBAnalyitcs()
        newAnalytics.className = className
        newAnalytics.fileName = file
        newAnalytics.method = method
        newAnalytics.timeStamp = self.nowDate
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
