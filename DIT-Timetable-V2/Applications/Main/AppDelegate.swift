//
//  AppDelegate.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 15/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        TBAnalytics.sendOpenApp(self)
        registerForPushNotifications(application)
        
        MyException.client()
        MyException.sharedClient?.setupExceptionHandler()
        
        //self.sendRawTimetable()

        
        //238, 50, 51
        //let navColor = self.readFromJSON()//UIColor(red: CGFloat(colRed)/255, green: CGFloat(colGreen)/255.0, blue: CGFloat(colBlue)/255.0, alpha: 0.5)
       // let navColor = UIColor(red: 38.0/255, green: 154.0/255, blue: 208.0/255, alpha: 0.5)
        
        UINavigationBar.appearance().tintColor = UIColor.white
        //UINavigationBar.appearance().barTintColor = navColor
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName: UIFont(name: "Avenir Next", size: 22)!]
       
        UIApplication.shared.applicationIconBadgeNumber = 0
        
//        let notification = TBNotification()
//        notification.setMessage("Testing123")
//        notification.setDeviceID("e4d8fbbe085dfa93e5212a3759a774bed6264b17a437ad94b51359c92105ab3a")
//        notification.sendNotification { (sent, returnMessage) in
//            
//            DispatchQueue.main.async {
//                if (sent) {
//                    print("success")
//                } else {
//                    print("error")
//                }
//            }
//        }
        
        // force NSException
//        let array = NSArray()
//        _ = array.object(at: 10)
        return true
    }
    
    func registerForPushNotifications(_ application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        
    }
    
    
    public func exceptionHandler(exception : NSException) {
        //print(exception)
        //print(exception.callStackSymbols.joined(separator: "\n"))
    }
    
    
    //MARK: Notifcation
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
         print(userInfo)
        
        if let aps = userInfo["aps"] as? NSDictionary {
            let message = aps["alert"]
            print("my messages : \(message)")
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)

        let installation = Installation(deviceToken: deviceToken)
        installation.sendInBackground("") { ( completed, data) in
            DispatchQueue.main.async {
                if (completed) {
                    print("success")
                } else {
                    print("error")
                }
            }

        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        TBAnalytics.sendOpenApp(self)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        TBAnalytics.sendCloseApp(self)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func readFromJSON() -> UIColor {
        //print("readFromJSON")
        //print(MyFileManager.readJSONFile(parseKey: "maps", keyVal: "id"))
        let defaultColor = UIColor(red: 38/255, green: 154/255, blue: 208/255, alpha: 1)
        return RCConfigManager.getColor(name: "navColor", defaultColor: defaultColor)
    }
    
}

