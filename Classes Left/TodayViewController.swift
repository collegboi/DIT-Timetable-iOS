//
//  TodayViewController.swift
//  Classes Left
//
//  Created by Timothy Barnard on 20/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayClassesLeftViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var tableView: UITableView!
    
    var todayClasses = [Timetable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        loadData()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsets.zero
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0, height: 280)
        } else {
            preferredContentSize = maxSize
        }
    }
    
    // MARK: - Loading of data
    func loadData() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let database = Database()
            
            let today = Date()
            let day = today.weekday()
            let indexVal = (day+5) % 7
            
            self.todayClasses = database.getDayTimetableAfterNow(dayNo: indexVal)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func createEmptyMessage(message:String) {
        let messageLabel = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "AvenirNext", size: 15)
        messageLabel.sizeToFit()
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = .none;
    }
    
    
}

// MARK: - TableView Data Source

extension TodayClassesLeftViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let todayClassCount = self.todayClasses.count
        if todayClassCount == 0 {
            let message = "You don't have any classes left. Have a nice day 😀"
            self.createEmptyMessage(message: message)
        } else {
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
        }
        return todayClassCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayCellTableViewCell
        
        let timetable = todayClasses[indexPath.row]
        /*cell.textLabel?.text = timetable.name
         cell.textLabel?.textColor = .black
         cell.textLabel?.font.withSize(17)
         
         cell.detailTextLabel?.text = timetable.room + " - " + timetable.timeStart
         cell.detailTextLabel?.textColor = .blue
         cell.detailTextLabel?.font.withSize(15)*/
        cell.setupCell(timetable: timetable)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: "ditTimetable://") {
            self.extensionContext?.open(url, completionHandler: {success in print("called url complete handler: \(success)")})
        }
        
    }
    
}
