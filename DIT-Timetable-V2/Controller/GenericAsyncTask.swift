//
//  GenericAsyncTask.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 15/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

public class HTTPConnection {
    
    class func getRequest(text: String) {
        
        let values = Bundle.contentsOfFile(plistName: "Settings.plist")
        let networkURL = values["FeedbackURL"]! as! String
        
        let escapedString = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(escapedString!)
        
        let url = networkURL + "?text=" + escapedString!
        
        let nsURL = NSURL(string: url)!

        
        var urlRequest = URLRequest(url: nsURL as URL)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
          
        })
        task.resume()
    }

    
    class func httpRequest(params : Dictionary<String, String>, url : String, httpMethod: String, postCompleted : @escaping (_ succeeded: Bool, _ data: NSData) -> ()) {
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        let session = URLSession.shared
        request.httpMethod = httpMethod
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            //err = error
            request.httpBody = nil
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            PrintLn.strLine(functionName: "httpRequest", message: "Response: \(String(describing: response))")
            //print(error)
            //let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            if ((error) != nil) {
                print(error!.localizedDescription)
                postCompleted(false, NSData())
            } else {
                postCompleted(true, data! as NSData)
            }
        })
        
        task.resume()
    }
    
    
    class func parseJSON(data : NSData) -> [AllTimetables] {
        var allTimetables = [AllTimetables]()
        
        for _ in 1...7 {
            let newTimetable = AllTimetables()
            allTimetables.append(newTimetable)
        }
        
        do {
            
            let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String:Any]
            let classes = parsedData["timetable"] as! NSArray
            
            for myClass in classes {
                
                let curTimetable = Timetable()
                
                let currentClass = myClass as! [String:Any]
                
                let dayNo = currentClass["dayNo"] as! Int
                curTimetable.name = currentClass["name"] as! String
                curTimetable.lecture = currentClass["lecture"] as! String
                curTimetable.room = currentClass["room"] as! String
                curTimetable.timeStart = currentClass["timeStart"] as! String
                curTimetable.timeEnd = currentClass["timeEnd"] as! String
                curTimetable.weeks = currentClass["weeks"] as! String
                curTimetable.groups = currentClass["groups"] as! String
                curTimetable.notifOn = 5
                
                allTimetables[dayNo].timetable.append(curTimetable)
                
            }
            
        } catch let error as NSError {
            print(error)
        }
        return allTimetables
    }
    
    class func parseJSONAndSave(data : NSData) ->Bool {
        
        var result : Bool = false
        do {
            
            let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String:Any]
            
            if let classes = parsedData["timetable"] as? NSArray {
                
                let database = Database()
                
                if(classes.count > 0) {
                    database.removeAll()
                }
                
                let notificationManager = NotificationManager()
                notificationManager.registerForNotifications()
                notificationManager.cancelAllNotifications()
            
                for myClass in classes {
                    
                    result = true
                    
                    let curTimetable = Class()
                
                    let currentClass = myClass as! [String:Any]
                
                    curTimetable.id = 0
                    curTimetable.day = currentClass["dayNo"] as! Int
                    curTimetable.name = currentClass["name"] as! String
                    curTimetable.lecture = currentClass["lecture"] as! String
                    curTimetable.room = currentClass["room"] as! String
                    curTimetable.timeStart = currentClass["timeStart"] as! String
                    curTimetable.timeEnd = currentClass["timeEnd"] as! String
                    curTimetable.weeks = currentClass["weeks"] as! String
                    curTimetable.groups = currentClass["groups"] as! String
                    curTimetable.notifOn = 5
                    
                    notificationManager.scheduleLocal(myClass: curTimetable)
                    
                    database.saveClass( myClass: curTimetable)
                    
                }
                let userDefaults = UserDefaults.standard
                userDefaults.set(1, forKey: "notification")
            }
        
        } catch let error as NSError {
            print(error)
        }
        return result
    }
    
    class func parseJSONConfigData(data : NSData) ->Bool {
        
        RCFileManager.writeJSONFile(jsonData: data, fileType: RCFileType.config)
        return true
    }
    
    class func parseJSONLangData( data: NSData ) -> Bool {
        RCFileManager.writeJSONFile(jsonData: data, fileType: RCFileType.language)
        return true
    }
    
    class func parseJSONDic(data : NSData) -> [String:Any]? {
        
        var returnData : [String:Any]?
        
        do {
            
            guard let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:Any] else {
               return returnData
            }
            
            returnData = parsedData
            
        } catch let error as NSError {
            print(error)
        }
        
        return returnData
    }




}
