//
//  DayTableViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 16/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit
import RealmSwift


class DayTableViewController: RCViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate {

    @IBOutlet weak var tableView: RCTableView!
    
    // MARK: - Data model for each walkthrough screen
    var index = 0               // the current page index
    var dayTimetable = [AllTimetables]()
    var days = [String]()
    var pickedRow : Int = -1
    var deletedRow : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewController(className: self, "DayTableViewController")
        
        days.append( RCConfigManager.getTranslation(name: "monday", defaultName: "Monday") )
        days.append( RCConfigManager.getTranslation(name: "tuesday", defaultName: "Tuesday") )
        days.append( RCConfigManager.getTranslation(name: "wednesday", defaultName: "Wednesday") )
        days.append( RCConfigManager.getTranslation(name: "thursday", defaultName: "Thursday") )
        days.append( RCConfigManager.getTranslation(name: "friday", defaultName: "Friday") )
        days.append( RCConfigManager.getTranslation(name: "saturday", defaultName: "Saturday") )
        days.append( RCConfigManager.getTranslation(name: "sunday", defaultName: "Sunday") )
        
        self.tableView.setupTableView(className: self, name: "tableView")
        
        self.tableView.tableFooterView = UIView()
        
        if( traitCollection.forceTouchCapability == .available){
            
            registerForPreviewing(with: self as UIViewControllerPreviewingDelegate, sourceView: view)
            
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pickedRow = -1
    
        self.deleteClass()
        
        self.title = self.days[index]
        self.navigationController?.navigationBar.topItem?.title = self.days[index]
        //self.tableView.reloadData()
        
        if self.dayTimetable.count > 2 {
            //self.checkForBreaks()
            self.reloadTable()
        } else {
            self.reloadTable()
        }
    }
    
    
    func deleteClass() {
        
        if self.dayTimetable.count > self.index {
        
            for ( index, value ) in self.dayTimetable[self.index].timetable.enumerated() {
                PrintLn.strLine(functionName: "deleteClass", message: value.markDeleted)
                if value.markDeleted {
                    self.dayTimetable[self.index].timetable.remove(at: index)
                }
            }
        }
        self.reloadTable()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dayTimetable.count > self.index {
            return self.dayTimetable[self.index].timetable.count
        } else {
            return 0
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "classIdentifier", for: indexPath) as! ClassTableViewCell

        cell.setupCellView(className: self, name: "ClassTableViewCell")
        
        let cellTimetable = self.dayTimetable[self.index].timetable
        
        cell.className.text = cellTimetable[indexPath.row].name
        
        if cellTimetable[indexPath.row].id != -1 {
        
            //cell.backgroundColor = UIColor.white
            cell.classLecture.text = " "+cellTimetable[indexPath.row].lecture
            cell.classLocation.text = cellTimetable[indexPath.row].room
            cell.classTime.text = " "+cellTimetable[indexPath.row].timeStart.convert24HrTo12Hr() + "-"+cellTimetable[indexPath.row].timeEnd.convert24HrTo12Hr()
            cell.classGroups.text = cellTimetable[indexPath.row].groups
        
            if checkIfClassNow(timeStart: cellTimetable[indexPath.row].timeStart, timeEnd: cellTimetable[indexPath.row].timeEnd) {
                cell.currentClass.backgroundColor = UIColor.green
            } else {
                //cell.currentClass.backgroundColor = UIColor.white
            }
        } else {
            
            cell.classLecture.text = ""
            cell.classLocation.text = ""
            cell.classTime.text = ""
            cell.classGroups.text = ""
            cell.backgroundColor = UIColor(red: 247.0/255.0, green: 231.0/255.0, blue: 189.0/255.0, alpha: 0.8)
            cell.currentClass.backgroundColor = UIColor(red: 247.0/255.0, green: 231.0/255.0, blue: 189.0/255.0, alpha: 0.8)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TBAnalytics.send(self)
        if self.dayTimetable[self.index].timetable[indexPath.row].id != -1 {
        
            self.pickedRow = indexPath.row
            self.performSegue(withIdentifier: "editClassSegue", sender: self)
        }
        self.tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    
    func checkForBreaks() {
     
        for i in 0...self.dayTimetable.count-2 {
            
            var breakTimetable = self.dayTimetable[self.index].timetable
            
            if ( i + 1) != breakTimetable.count-2 && breakTimetable[i].id != -1 && breakTimetable[i+1].id != -1 {
            
                if breakTimetable[i].timeEnd.StringTimetoTime() < breakTimetable[i+1].timeStart.StringTimetoTime()
                && ( breakTimetable[i+1].timeStart.StringTimetoTime() != breakTimetable[i].timeStart.StringTimetoTime() ) {
                   
                    let breakClass = Timetable()
                    
                    let endHr = breakTimetable[i+1].timeStart.StringTimetoTime().hour()
                    let endMin = breakTimetable[i+1].timeStart.StringTimetoTime().minute()
                    
                    let startHr = breakTimetable[i].timeEnd.StringTimetoTime().hour()
                    let startMin = breakTimetable[i].timeEnd.StringTimetoTime().minute()
                    
                    var breakTime = "Break: "
                    
                    if (endHr - startHr) > 0 {
                        breakTime += (String)( endHr - startHr )+"hr/s "
                    }
                    
                    if(endMin - startMin) > 0 {
                        breakTime += (String)( endMin - startMin)+"min/s"
                    }
    
                
                    breakClass.name = breakTime
                    breakClass.id = -1

                    self.dayTimetable[self.index].timetable.insert(breakClass, at: i+1)
                }
            }
        }
        
        self.reloadTable()
    }
    
    func reloadTable () {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editClassSegue" && self.pickedRow != -1 {
            if let destinationVC = segue.destination as? EditClassTableViewController {
                destinationVC.allTimestables = self.dayTimetable
                destinationVC.dayNo = self.index
                destinationVC.classRow = self.pickedRow
                PrintLn.strLine(functionName: "segue sending", message: self.dayTimetable.count)
            }
        }
    }
    
    //unwind segue function
    @IBAction func unwindToVC(_ segue:UIStoryboardSegue) {
        
       /* if(segue.source .isKind(of: EditClassViewController.self)) {
            print("Unwind function")
            let view2:EditClassViewController = segue.source as! EditClassViewController
            print(view2.classRow)
            self.deletedRow = view2.classRow
        }*/
    }
    
    func checkIfClassNow(timeStart: String, timeEnd: String) -> Bool {
        
        if getDayOfWeek() == self.index {
            
            let date = Date()
            let startDate = timeStart.StringTimetoTime()
            let endDate = timeEnd.StringTimetoTime()
            
            if ( date >= startDate ) && ( date <= endDate ) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func getDayOfWeek()->Int {
        
        let date = Date()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: date)
        let weekDay = myComponents.weekday
        return weekDay!-2
    }
}

// MARK : UIViewControllerPreviewingDelegate
extension DayTableViewController {

    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: self.view.convert(location, to: tableView)) else { return nil }
        
        guard let cell = self.tableView.cellForRow(at: indexPath) else { return nil }
        
        guard let detailClass = storyboard?.instantiateViewController(withIdentifier: "DetailClassView") as? DetailClassViewController else { return nil }
        
        detailClass.preferredContentSize = CGSize(width: 0.0, height: 300)
        
        detailClass.name = self.dayTimetable[self.index].timetable[indexPath.row].name
        detailClass.time = self.dayTimetable[self.index].timetable[indexPath.row].timeStart+"-"+self.dayTimetable[self.index].timetable[indexPath.row].timeEnd
        detailClass.room = self.dayTimetable[self.index].timetable[indexPath.row].room
        detailClass.lecture = self.dayTimetable[self.index].timetable[indexPath.row].lecture
        detailClass.group = self.dayTimetable[self.index].timetable[indexPath.row].groups
        
        
        previewingContext.sourceRect = cell.frame
        
        return detailClass
        
    }
    
    @objc(previewingContext:commitViewController:) func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        //showDetailViewController(viewControllerToCommit, sender: self)
    }
    
}
