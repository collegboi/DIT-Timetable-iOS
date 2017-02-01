//
//  NotificationManager.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 18/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationAction : String {
    case myClass = "myClass"
}

class NotificationManager: NSObject {
    
    private var notificationGranted : Bool = true
    
    func registerForNotifications() {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                
                self.notificationGranted = granted
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func notificationsCount() -> Int {
        
        var returnCount = 0
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests { (notifications) in
                print("Count: \(notifications.count)")
                returnCount = notifications.count
                //for item in notifications {
                    //print(item.content)
                //}
            }
        }
        return returnCount
    }
    
    func cancelAllNotifications() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func removeANotification( notificaitonID : Int ) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(notificaitonID)])
        } else {
            // Fallback on earlier versions
        }
    }
    
    func createAllNotifications( myTimetable : [AllTimetables] ) {
        
        for dayTimetable in myTimetable {
            
            for myClass in dayTimetable.timetable {
                
                if myClass.notifOn > 0 {
                    
                    self.createNotification(day: myClass.dayNo, time: myClass.timeStart, name: myClass.name, room: myClass.room, lecture: myClass.lecture, id : String(myClass.id), minsBefore: myClass.notifOn )
                }
            }
        }
    }
    
    func scheduleLocal(myClass : Class ) {
        self.createNotification(day: myClass.day, time: myClass.timeStart, name: myClass.name, room: myClass.room, lecture: myClass.lecture, id : String(myClass.id), minsBefore: myClass.notifOn )
    }
    
    func createNotification(myTimetable : Timetable ) {
        self.createNotification(day: myTimetable.dayNo, time: myTimetable.timeStart, name: myTimetable.name, room: myTimetable.room, lecture: myTimetable.lecture, id : String(myTimetable.id), minsBefore: myTimetable.notifOn )
    }
    
    func createNotification( day : Int,  time : String, name : String, room : String, lecture : String, id : String, minsBefore: Int) {
        
        if #available(iOS 10.0, *) {
            
            //let timeSplit = time.components(separatedBy: ":")
            let dateFormatter = DateFormatter()
            
            let locale = NSLocale.current
            var dateStart = Date()
            
            let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)!
            
            if dateFormat.localizedStandardContains("a") {
                print("12 hour")
                dateFormatter.dateFormat = "H:mm"
                if let date12 = dateFormatter.date(from: time) {
                    dateFormatter.dateFormat = "h:mm a"
                    let date22 = dateFormatter.string(from: date12)
                    print(date22)
                    print("output \(time)")
                } else {
                    
                }
//                dateFormatter.dateFormat = "h:mm a"
//                dateStart = dateFormatter.date(from: time)!
            }
            else {
                print("24 hour")
                dateFormatter.dateFormat = "HH:mm"
                dateStart = dateFormatter.date(from: time)!
            }
            
            
            //NSException(name: NSExceptionName(rawValue: "Raven test exception"), reason: "No reason", userInfo: nil).raise()
            
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let minusFiveDate = myCalendar.date(byAdding: .minute, value: ( minsBefore * -1 ), to: dateStart )
            
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "Class Starts"
            content.body = name + " is starting at: "+time+".\nRoom: "+room+"\nLecture: "+lecture
            content.categoryIdentifier = "com.barnard.localNotification"
            //content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default()
            
            var dateComponents = DateComponents()
            dateComponents.hour = minusFiveDate!.hour()
            dateComponents.minute = minusFiveDate!.minute()
            dateComponents.weekday = day + 2
            
            //print(dateComponents)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
            
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            center.add(request) { (error) in
                if error != nil {
                    print(error ?? "Testing")
                }
            }
            //print("Notification Setup")
        }

    }
    
    func testModeNotificaitons() {
        self.createNotification(day: 0, time: "16:02", name: "test mode", room: "", lecture: "", id : String(99999), minsBefore: 1 )
    }
   
    /*func setupInitialNotifications( ) {
        
        print("notification setting up")
        
        if self.notificationGranted {
            
            // Register an Actionable Notification
            if #available(iOS 10.0, *) {
                let myClassAction = UNNotificationAction(identifier: NotificationAction.myClass.rawValue, title: "High Five", options: [])
                
            
                let category = UNNotificationCategory(identifier: "test", actions: [myClassAction],  intentIdentifiers: [], options: UNNotificationCategoryOptions.customDismissAction)
                
                //let category = UNNotificationCategory(identifier: "wassup", actions: [myClassAction], minimalActions: [myClassAction], intentIdentifiers: [], options: [.customDismissAction])
            
                UNUserNotificationCenter.current().setNotificationCategories([category])
            
                let highFiveContent = UNMutableNotificationContent()
                highFiveContent.title = "Wassup?"
                highFiveContent.body = "Can I get a high five?"
            
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
                let highFiveRequestIdentifier = "sampleRequest"
                let highFiveRequest = UNNotificationRequest(identifier: highFiveRequestIdentifier, content: highFiveContent, trigger: trigger)
                UNUserNotificationCenter.current().add(highFiveRequest) { (error) in
                    // handle the error if needed
                    print(error)
                }
                
                print("notification setup")
                
            } else {
                // Fallback on earlier versions
            }
        }*/
        
    //}
    
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    private func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        
        // Response has actionIdentifier, userText, Notification (which has Request, which has Trigger and Content)
        switch response.actionIdentifier {
        case NotificationAction.myClass.rawValue:
            print("High Five Delivered!")
        default: break
        }
    }
    
    @available(iOS 10.0, *)
    private func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        
        // Delivers a notification to an app running in the foreground.
    }
}
