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
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var connectivityHandler : ConnectivityHandler?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        let database = Database()
        
        //238, 50, 51
        let navColor = UIColor(red: 44.0/255, green: 153.0/255, blue: 206.0/255, alpha: 0.5)
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = navColor
        UINavigationBar.appearance().isTranslucent = false
        
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 21)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = attrs
       
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if WCSession.isSupported() {
            self.connectivityHandler = ConnectivityHandler()
            connectivityHandler?.setupDatabase(database: database)
            connectivityHandler?.session.sendMessage(["msg" : "Message \(0)"], replyHandler: nil) { (error) in
                NSLog("%@", "Error sending message: \(error)")
            }
            
        } else {
            NSLog("WCSession not supported (f.e. on iPad).")
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

