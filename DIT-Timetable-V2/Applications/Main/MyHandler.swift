//
//  MyHandler.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 30/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
#endif


public enum ErrorLogLevel: String {
    case Debug = "debug"
    case Info = "info"
    case Warning = "warning"
    case Error = "error"
    case Fatal = "fatal"
}

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
     Get the shared MyException instance
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
    
    
    @discardableResult
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
                tags["Build name"] = RCFileManager.readPlistString(value: "CFBundleDisplayName") as AnyObject?
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
        
        #if RELEASE
        #endif
        
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
            UserDefaults.standard.set(exception.userInfo ?? "Nil", forKey: "userInfo" )
            UserDefaults.standard.set(exception.callStackReturnAddresses , forKey: "stackReturnAddress")
            UserDefaults.standard.set(exception.callStackSymbols , forKey: "stackSymbols")
        }
        
        NSSetUncaughtExceptionHandler(exceptionHandler)
        
    }
    
    //MARK: - Messages
    
    /**
     Capture a message
     
     :param: message  The message to be logged
     */
    public func captureMessage(message : String, method: String? = #function , file: String? = #file, line: Int = #line) {
        self.captureMessage(message: message, level: .Info, additionalExtra:[:], additionalTags:[:], method:method, file:file, line:line)
    }
    
    /**
     Capture a message
     :param: message  The message to be logged
     :param: level  log level
     */
    public func captureMessage(message: String, level: ErrorLogLevel, method: String? = #function , file: String? = #file, line: Int = #line){
        self.captureMessage(message: message, level: level, additionalExtra:[:], additionalTags:[:], method:method, file:file, line:line)
    }
    
    
    //MARK: - Error
    
    /**
     Capture an error message
     
     :param: error NSError type
     */
    public func captureError(error : NSError, method: String? = #function, file: String? = #file, line: Int = #line) {
        
    }

    
    /**
     Capture a message
     :param: message  The message to be logged
     :param: level  log level
     :param: additionalExtra  Additional data that will be sent with the log
     :param: additionalTags  Additional tags that will be sent with the log
     */
    public func captureMessage(message: String, level: ErrorLogLevel, additionalExtra:[String: AnyObject], additionalTags: [String: AnyObject], method:String? = #function, file:String? = #file, line:Int = #line) {
//        var stacktrace : [AnyObject] = []
//        var culprit : String = ""
//        
//        if (method != nil && file != nil && line > 0) {
//            let filename = (file! as NSString).lastPathComponent;
//            let frame = ["filename" : filename, "function" : method!, "lineno" : line]
//            stacktrace = [frame]
//            culprit = "\(method!) in \(filename)"
//        }
//        
//        let data = self.prepareDictionaryForMessage(message, level:level, additionalExtra:additionalExtra, additionalTags:additionalTags, culprit:culprit, stacktrace:stacktrace, exception:[:])
//        
//        self.sendDictionary(data)
    }
    
    
    //MARK: - Exception Capture
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
        
        
        //Building the Exeception object
        dict["stacktrace"] = stacktrace as AnyObject?
        dict["exeptionName"] = exception.name as AnyObject?
        dict["reason"] = exception.reason as AnyObject? ?? "" as AnyObject?
        dict["userInfo"] = exception.userInfo as AnyObject?
        dict["stackReturnAddress"] = exception.callStackReturnAddresses as AnyObject?
        dict["stackSymbols"] =  exception.callStackSymbols as AnyObject?
        
        dict = getExecptionObjectReady(data: dict)
        
        
        if sendNow {
            self.sendExecptions(data: dict)
        } else {
            
            UserDefaults.standard.set(exception.name.rawValue, forKey: "name")  //Integer
            UserDefaults.standard.set(exception.reason ?? "Nil", forKey: "reason") //setObject
            UserDefaults.standard.set( exception.userInfo ?? "Nil", forKey: "userInfo" )
            UserDefaults.standard.set(dict, forKey: "stacktrace")
            UserDefaults.standard.set(exception.callStackReturnAddresses , forKey: "stackReturnAddress")
            UserDefaults.standard.set(exception.callStackSymbols , forKey: "stackSymbols")
        }
    }
    
    
    internal func getExecptionObjectReady( data: [String: AnyObject] ) -> [String: AnyObject] {
        
        var returnExeptionObj : [String:AnyObject] = data;
    
        returnExeptionObj["timestamp"] = self.nowDate as AnyObject
        returnExeptionObj["platform"] = "swift" as AnyObject
        
        return returnExeptionObj
        
    }
    
    internal func sendExecptions( data: [String:AnyObject] ) {
        
        
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
                UserDefaults.standard.removeObject(forKey: "userInfo" )
                UserDefaults.standard.removeObject(forKey: "stacktrace")
                UserDefaults.standard.removeObject(forKey: "stackReturnAddress")
                UserDefaults.standard.removeObject(forKey: "stackSymbols")
                //postCompleted(true, data! as NSData)
            }
        })
        
        task.resume()

    }
    
    internal func checkAndSendErrors() {
        
        var newData = [String:AnyObject]()
        
        let execeptionName = UserDefaults.standard.string(forKey: "name")
        let execeptionReason = UserDefaults.standard.string(forKey: "reason")
        let exeptionUserInfo = UserDefaults.standard.object(forKey: "userInfo")
        let exeptionStactTrace = UserDefaults.standard.object(forKey: "stacktrace")
        let stackReturnAddress = UserDefaults.standard.object(forKey: "stackReturnAddress")
        let stackSymbols = UserDefaults.standard.object(forKey: "stackSymbols")
        
        if execeptionName != nil && execeptionReason != nil {
        
            newData["tags"] = self.tags as AnyObject?
            newData["exeptionName"] = execeptionName as AnyObject?
            newData["reason"] = execeptionReason as AnyObject?
            newData["stacktrace"] = exeptionStactTrace as AnyObject?
            newData["userInfo"] = exeptionUserInfo as AnyObject?
            newData["stackSymbols"] = stackSymbols as AnyObject?
            newData["stackReturnAddress"] = stackReturnAddress as AnyObject?
        
            newData = getExecptionObjectReady(data: newData)
            
            self.sendExecptions(data: newData)
        }
    }
    
    
}
