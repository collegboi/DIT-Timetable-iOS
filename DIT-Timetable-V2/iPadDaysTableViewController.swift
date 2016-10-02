//
//  iPadDaysTableViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 01/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class iPadDaysTableViewController: UITableViewController {

    @IBOutlet weak var allNotificaitonsOff: UIBarButtonItem!
    var allTimetables = [AllTimetables]()
    var dayTableViewController: DayTableViewController? = nil
    var notificationsSet : Bool = true
    var firstIndex : IndexPath?
    
    // Initialize it right away here
    fileprivate let days = ["Monday",
                            "Tuesday",
                            "Wednesday",
                            "Thursday",
                            "Friday",
                            "Saturday",
                            "Sunday"];
    
    
    // make the status bar white (light content)
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        let today = Date()
        let day = today.weekday()
        let indexVal = (day+5) % 7
        self.firstIndex = IndexPath(row: indexVal, section: 0 )
        
        let defaults =  UserDefaults.standard
        
        if defaults.integer(forKey: "notification") == 1 {
            self.turnOnOffNotification(OnOff: true)
        } else {
            self.turnOnOffNotification(OnOff: false)
        }
        
        self.getTimetablesDB()
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.dayTableViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DayTableViewController
        }
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getTimetablesDB() {
        
        let database = Database()
        self.allTimetables = database.getAllTimetables()
        self.tableView.selectRow(at: self.firstIndex, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "showDetail", sender: self.firstIndex)
    }
    
    
    @IBAction func allNotificaitonsOff(_ sender: AnyObject) {
        
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
            self.allNotificaitonsOff.image = UIImage(named : "notificationOn")
        } else {
            self.notificationsSet = false
            self.allNotificaitonsOff.image = UIImage(named: "notificationOff")
        }
    }


}

extension iPadDaysTableViewController {
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.days.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath)
        cell.textLabel?.text = self.days[indexPath.row]
        //cell.isSelected = ( indexPath == self.firstIndex )
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            
            if self.firstIndex == nil {
                
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let controller = (segue.destination as! UINavigationController).topViewController as! DayTableViewController
                    controller.index = (indexPath as NSIndexPath).row
                    controller.dayTimetable = self.allTimetables
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
                
            } else if self.firstIndex != nil {
                let controller = (segue.destination as! UINavigationController).topViewController as! DayTableViewController
                controller.index = (self.firstIndex! as NSIndexPath).row
                controller.dayTimetable = self.allTimetables
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                self.firstIndex = nil
                
                // Get row from sender, which is an NSIndexPath
            }
        }
    }

    

}
