//
//  TimetableViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 16/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import RealmSwift
import UIKit

class TimetableViewController: UIPageViewController {
    
    // Some hard-coded data for our walkthrough screens
    var allTimetables = [AllTimetables]()
    @IBOutlet weak var toggleNotifications: UIBarButtonItem!
    var notificationsSet : Bool = true
    
    
    // make the status bar white (light content)
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults =  UserDefaults.standard
        
        if defaults.integer(forKey: "notification") == 1 {
            self.turnOnOffNotification(OnOff: true)
        } else {
            self.turnOnOffNotification(OnOff: false)
        }
        self.getTimetablesDB()
        // this class is the page view controller's data source itself
        self.dataSource = self
        
    }
    @IBAction func addClassButton(_ sender: Any) {
        let notificationName = Notification.Name("NotificationIdentifier")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }

    
    @IBAction func toggleNotifications(_ sender: AnyObject) {
        
        let defaults = UserDefaults.standard
        let notificationManager = NotificationManager()
        notificationManager.registerForNotifications()
        
        if notificationsSet {
            defaults.set(0, forKey: "notification")
            notificationManager.cancelAllNotifications()
            self.turnOnOffNotification(OnOff: false)
        } else {
            defaults.set(1, forKey: "notification")
            notificationManager.createAllNotifications(myTimetable: self.allTimetables )
            self.turnOnOffNotification(OnOff: true)
        }
    }
    
    func turnOnOffNotification( OnOff : Bool) {
        
        if OnOff {
            self.notificationsSet = true
            self.toggleNotifications.image = UIImage(named : "notificationOn")
        } else {
            self.notificationsSet = false
            self.toggleNotifications.image = UIImage(named: "notificationOff")
        }
    }
    
    func getTimetablesDB() {
        
        let database = Database()
        
        self.allTimetables = database.getAllTimetables()
        
        let today = Date()
        let day = today.weekday()
        let indexVal = (day+5) % 7
        // create the first walkthrough vc
        if let startWalkthroughVC = self.viewControllerAtIndex(indexVal) {
            self.setViewControllers([startWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
    }

    
    // MARK: - Navigate
    
    func nextPageWithIndex(_ index: Int) {
        if let nextWalkthroughVC = self.viewControllerAtIndex(index+1) {
            setViewControllers([nextWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(_ index: Int) -> DayTableViewController? {
        
        if index == NSNotFound || index < 0 || index >= self.allTimetables.count {
            return nil
        }
    
    
        // create a new walkthrough view controller and assing appropriate date
        if let dayTableViewController = storyboard?.instantiateViewController(withIdentifier: "DayTableViewController") as? DayTableViewController {
            dayTableViewController.index = index
            dayTableViewController.dayTimetable = self.allTimetables
            return dayTableViewController
        }
    
        return nil
    }
}
    
extension TimetableViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! DayTableViewController).index
        index += 1
        return self.viewControllerAtIndex(index)
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! DayTableViewController).index
        index -= 1
        return self.viewControllerAtIndex(index)
    }
}
