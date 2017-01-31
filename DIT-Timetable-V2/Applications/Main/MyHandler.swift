//
//  MyHandler.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 30/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

private var _MyExceptionSharedInstance : MyException?

public class MyException: NSObject {
    
    public var tags: [String: AnyObject]
    
    private var dateFormatter : DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
    
    private var nowDate: String {
        return self.dateFormatter.string(from: NSDate() as Date)
    }
    
    //MARK: - Init

    /**
     Get the shared RavenClient instance
     */
    public class var sharedClient: MyException? {
        return _MyExceptionSharedInstance
    }
    
    public init(tags: [String: AnyObject] ) {
        self.tags = tags
        super.init()
        
        setDefaultTags()
        
        if (_MyExceptionSharedInstance == nil) {
            _MyExceptionSharedInstance = self
        }
    }
    
    public class func client() -> MyException? {
        
        let client = MyException(tags: [:])

        return client
    }

    
    //MARK: - Internal methods
    internal func setDefaultTags() {
        
        if tags["Build version"] == nil {
            if let buildVersion: AnyObject = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject?
            {
                tags["Build version"] = buildVersion as AnyObject?
            }
        }

        #if os(iOS) || os(tvOS)
            if (tags["OS version"] == nil) {
                tags["OS version"] = UIDevice.current.systemVersion as AnyObject?
            }

            if (tags["Device model"] == nil) {
                tags["Device model"] = UIDevice.current.model as AnyObject?
            }
        #endif
        
    }
    
    /**
     Automatically capture any uncaught exceptions
     */
    public func setupExceptionHandler() {
    
        checkAndSendErrors()
        
        func exceptionHandler(exception : NSException) {
            
            
            NSLog("Name:" + exception.name.rawValue)
            if exception.reason == nil
            {
                NSLog("Reason: nil")
            }
            else
            {
                NSLog("Reason:" + exception.reason!)
            }
        
            UserDefaults.standard.set(exception.name.rawValue, forKey: "name")  //Integer
            UserDefaults.standard.set(exception.reason ?? "Nil", forKey: "reason") //setObject
        }
        
        NSSetUncaughtExceptionHandler(exceptionHandler)
        
    }
    
    public func captureError(error : NSError, method: String? = #function, file: String? = #file, line: Int = #line) {
        
    }
    
    public func captureException(exception: NSException, method:String? = #function, file:String? = #file, line:Int = #line, sendNow:Bool = true) {
        //let message = "\(exception.name): \(exception.reason ?? "")"
        //let exceptionDict = ["type": exception.name, "value": exception.reason ?? ""] as [String : Any]
        
        var dict = [String:AnyObject]()
        
        var stacktrace = [[String:AnyObject]]()

        if (method != nil && file != nil && line > 0) {
            var frame = [String: AnyObject]()
            frame = ["filename" : (file! as NSString).lastPathComponent as AnyObject, "function" : method! as AnyObject, "lineno" : line as AnyObject]
            stacktrace = [frame]
        }

        let callStack = exception.callStackSymbols

        for call in callStack {
            stacktrace.append(["function": call as AnyObject])
        }
        
        dict["stacktrace"] = stacktrace as AnyObject?
        dict["exeptioName"] = exception.name as AnyObject?
        dict["reason"] = exception.reason as AnyObject?? ?? "" as AnyObject?
        
        if sendNow {
            self.sendExecptions(data: dict)
        } else {
            
            
            UserDefaults.standard.set(exception.name.rawValue, forKey: "name")  //Integer
            UserDefaults.standard.set(exception.reason ?? "Nil", forKey: "reason") //setObject
            UserDefaults.standard.set(dict, forKey: "stacktrace")
        }
    }
    
    func sendExecptions( data: [String:AnyObject] ) {
        
        
        let className = "Exceptions"
        
        let apiEndpoint = "http://Timothys-MacBook-Pro.local:8181/storage/"
        let networkURL = apiEndpoint + className
        
        let request = NSMutableURLRequest(url: NSURL(string: networkURL)! as URL)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        } catch {
            //err = error
            request.httpBody = nil
        }
        
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            
            if ((error) != nil) {
                print(error!.localizedDescription)
                //postCompleted(false, NSData())
            } else {
                UserDefaults.standard.removeObject(forKey: "name")
                UserDefaults.standard.removeObject(forKey: "reason")
                //postCompleted(true, data! as NSData)
            }
        })
        
        task.resume()

    }
    
    func checkAndSendErrors() {
        
        
        //if let json = self.toJSON() {
        //let data = self.convertStringToDictionary(text: json)
        
        var newData = [String:AnyObject]()
        //newData = data!
        
        let execeptionName = UserDefaults.standard.string(forKey: "name")
        let execeptionReason = UserDefaults.standard.string(forKey: "reason")
        //defaults.setObject("Coding Explorer", forKey: "userNameKey")
        
        if execeptionName != nil && execeptionReason != nil {
        
            newData["tags"] = self.tags as AnyObject?
            newData["exeptioName"] = execeptionName as AnyObject?
            newData["reason"] = execeptionReason as AnyObject?
        
            self.sendExecptions(data: newData)
        }
    }
    
    
}
