//
//  EditClassTableViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 24/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class EditClassTableViewController: UITableViewController, UITextFieldDelegate, AlertMessageDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var dayPicker: UIPickerView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var notifcationPicker: UIDatePicker!
    
    @IBOutlet weak var moduleName: UITextField!
    @IBOutlet weak var classRoom: UITextField!
    @IBOutlet weak var classLecture: UITextField!
    @IBOutlet weak var classGroups: UITextField!
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var saveLabel: UILabel!
    
    var sectionTitles = [String]()
    
    var notificationPicked : Bool = false
    var timerPicked : Bool = false
    var dayPicked : Bool = false
    var indexPathSel : IndexPath?
    
    //var currentClass = Timetable()
    var allTimestables = [AllTimetables]()
    var dayNo : Int = 0
    var updateDayNo : Int = 0
    
    var notifOn : Int = 1
    let database = Database()
    let notificationManager = NotificationManager()
    var classRow : Int = 0
    var deleteClass : Bool = false
    var isEditMode = false
    var dayPickerDataSource = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        dayPickerDataSource.append("Monday")
        dayPickerDataSource.append("Tuesday")
        dayPickerDataSource.append("Wednesday")
        dayPickerDataSource.append("Thursday")
        dayPickerDataSource.append("Friday")
        dayPickerDataSource.append("Saturday")
        dayPickerDataSource.append("Sunday")
        
        
        sectionTitles.append("Class Details")
        sectionTitles.append(" ") //Notifications
        sectionTitles.append("Class Time")
        sectionTitles.append("Class Day")
        sectionTitles.append( " " ) //save
        sectionTitles.append( " " ) //delete
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.backgroundColor = UIColor.groupTableViewBackground //UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        
        
        self.classLecture.delegate = self
        self.classRoom.delegate = self
        self.classGroups.delegate = self
        
        self.dayPicker.dataSource = self
        self.dayPicker.delegate = self
        
        var startTime = "00:00"
        var endTime = "00:00"
        let dayNo = self.dayPickerDataSource[self.dayNo]
        var notifHr = 0
        var notifMin = 5
        
        if self.classRow > 0 {
            
            isEditMode = true
            
            let myClass = self.database.getClass(classID: self.allTimestables[self.dayNo].timetable[self.classRow].id)
            self.notificationPicked = ( myClass.notifOn > 0 )
            self.updateDayNo = self.dayNo
            
            self.moduleName.text = self.allTimestables[self.dayNo].timetable[self.classRow].name
            self.classLecture.text = self.allTimestables[self.dayNo].timetable[self.classRow].lecture
            self.classRoom.text = self.allTimestables[self.dayNo].timetable[self.classRow].room
            self.classGroups.text = self.allTimestables[self.dayNo].timetable[self.classRow].groups
            
            startTime = self.allTimestables[self.dayNo].timetable[self.classRow].timeStart.convertToCurrentTimeFormat()
            endTime = self.allTimestables[self.dayNo].timetable[self.classRow].timeEnd.convertToCurrentTimeFormat()
            
            (notifHr, notifMin) = self.minToHoursMinutes(minutes: self.allTimestables[self.dayNo].timetable[self.classRow].notifOn )
        }
        
        self.notificationSwitch.isOn = self.notificationPicked
        
        var indexPath = IndexPath(row: 0, section: 1 )
        
        indexPath = IndexPath(row: 0, section: 2 )
        var cell = self.tableView.cellForRow(at: indexPath)
        cell?.textLabel?.text = "Start"
        cell?.detailTextLabel?.text = startTime
        
        indexPath = IndexPath(row: 1, section: 2 )
        cell = self.tableView.cellForRow(at: indexPath)
        cell?.textLabel?.text = "End"
        cell?.detailTextLabel?.text = endTime
        
        indexPath = IndexPath(row: 0, section: 3)
        cell = self.tableView.cellForRow(at: indexPath)
        cell?.textLabel?.text = dayNo
        
        
        let components = NSDateComponents()
        components.setValue(notifMin, forComponent: .minute)
        components.setValue(notifHr, forComponent: .hour)
        self.notifcationPicker.date = NSCalendar.current.date(from: components as DateComponents)!
    
        
        //self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func minToHoursMinutes (minutes : Int) -> (Int, Int) {
        return (minutes / 60, (minutes % 60))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitles[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0  :
            return 4
        case 1  :
            return ( self.notificationPicked == true ? 2 : 1 )
        case 2  :
            return ( self.timerPicked == true ? 3 : 2 )
        case 3  :
            return ( self.dayPicked == true ? 2 : 1)
        case 4  :
            return 1
        case 5  :
            return 1
        default :
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPathSel = indexPath
        if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 0 {
            
            self.notificationPicked = ( self.notificationPicked ==  false ? true : false )
            self.notificationSwitch.isOn = self.notificationPicked
            self.tableView.reloadData()
            
        } else if (indexPath as NSIndexPath).section == 2 && ( (indexPath as NSIndexPath).row == 0 || (indexPath as NSIndexPath).row == 1 ) {
            
            self.timerPicked = ( self.timerPicked ==  false ? true : false )
            
            self.tableView.reloadData()
        
        } else if (indexPath as NSIndexPath).section == 3 && (indexPath as NSIndexPath).row == 0 {
            
            self.dayPicked = ( self.dayPicked ==  false ? true : false )
            
            self.tableView.reloadData()
            
        } else if (indexPath as NSIndexPath).section == 4 && (indexPath as NSIndexPath).row == 0 {
            
            self.deleteCurrrentClass()
            
        } else if (indexPath as NSIndexPath).section == 5 && (indexPath as NSIndexPath).row == 0 {
            
            self.saveCurrentClass()
        }
    }
    
    @IBAction func timePicker(_ sender: AnyObject) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.string(from: self.timePicker.date)
        
        let cell = self.tableView.cellForRow(at: self.indexPathSel!)
        
        cell?.detailTextLabel?.text = strDate
    }
    
    

    func saveCurrentClass() {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var indexPath = IndexPath(row: 0, section: 2 )
        var cell = self.tableView.cellForRow(at: indexPath)
        let timeStart = (cell?.detailTextLabel?.text)!.convertTo24hrFomat()
        
        indexPath = IndexPath(row: 1, section: 2 )
        cell = self.tableView.cellForRow(at: indexPath)
        let timeEnd = (cell?.detailTextLabel?.text)!.convertTo24hrFomat()
        
        indexPath = IndexPath(row: 0, section: 3)
        cell = self.tableView.cellForRow(at: indexPath)
        let dayIndex = self.dayPickerDataSource.index(of: cell!.textLabel!.text! )
        
        let startTime = dateFormatter.date(from: timeStart)
        let endTime = dateFormatter.date(from: timeEnd)
        
        
        if startTime! < endTime! {
        
            var notifytime = 0
            
            if self.notificationPicked {
                let hr = self.notifcationPicker.date.hour()
                let min = self.notifcationPicker.date.minute()
                notifytime = ( hr * 60) + min
            }

            
            if self.isEditMode {
                
                self.allTimestables[self.dayNo].timetable[self.classRow].name = self.moduleName.text!
                self.allTimestables[self.dayNo].timetable[self.classRow].lecture = self.classLecture.text!
                self.allTimestables[self.dayNo].timetable[self.classRow].room = self.classRoom.text!
                self.allTimestables[self.dayNo].timetable[self.classRow].groups = self.classGroups.text!
                self.allTimestables[self.dayNo].timetable[self.classRow].notifOn = notifytime
                self.allTimestables[self.dayNo].timetable[self.classRow].name = self.moduleName.text!
                self.allTimestables[self.dayNo].timetable[self.classRow].dayNo = self.updateDayNo
                self.allTimestables[self.dayNo].timetable[self.classRow].timeStart = timeStart
                self.allTimestables[self.dayNo].timetable[self.classRow].timeEnd = timeEnd
                self.allTimestables[self.dayNo].timetable[self.classRow].dayNo = dayIndex!
                
                self.database.updateTimetable(timetable: self.allTimestables[self.dayNo].timetable[self.classRow])
                
                //if day changed then delete previous and add new
                if dayIndex != self.dayNo {
                    
                    PrintLn.strLine(functionName: "changeClassDay", message: dayNo)
                    self.allTimestables[self.dayNo].timetable[self.classRow].dayNo = dayNo
                    self.allTimestables[self.dayNo].timetable[self.classRow].markDeleted = true
                    self.updateDayNo = dayNo
                    
                    let classChange = Timetable()
                    classChange.id = self.allTimestables[self.dayNo].timetable[self.classRow].id
                    classChange.groups = self.classGroups.text!
                    classChange.lecture = self.classLecture.text!
                    classChange.name = self.moduleName.text!
                    classChange.notifOn = notifytime
                    classChange.timeStart = timeStart
                    classChange.timeEnd = timeEnd
                    classChange.weeks = self.allTimestables[self.dayNo].timetable[self.classRow].weeks
                    classChange.markDeleted = false
                    classChange.dayNo = dayIndex!
                    self.allTimestables[dayIndex!].timetable.append(classChange)
                }
            } else {
                
                let curTimetable = Class()
                curTimetable.id = 0
                curTimetable.day = self.updateDayNo
                curTimetable.name = self.moduleName.text ?? ""
                curTimetable.lecture = self.classLecture.text ?? ""
                curTimetable.room = self.classRoom.text ?? ""
                curTimetable.timeStart = timeStart
                curTimetable.timeEnd = timeEnd
                curTimetable.weeks = ""
                curTimetable.groups = self.classGroups.text ?? ""
                curTimetable.notifOn = notifytime
                
                let id  = self.database.saveClass( myClass: curTimetable)
                
                let newClass = Timetable()
                newClass.id = id
                newClass.lecture = curTimetable.lecture
                newClass.timeStart = curTimetable.timeStart
                newClass.timeEnd = curTimetable.timeEnd
                newClass.dayNo = curTimetable.day
                newClass.name = curTimetable.name
                newClass.groups = curTimetable.groups
                newClass.room = curTimetable.room
                newClass.notifOn = notifytime
                
                self.allTimestables[self.dayNo].timetable.append(newClass)
            }
            
            self.updateNotifications()
            //self.updateClass = true
            
            self.performSegue(withIdentifier: "unwindSegue", sender: self)
        } else {
            let showAlert = ShowAlert()
            showAlert.alertDelegate = self
            let messageArr = ["OK"]
            let timeErrorMessage = "End time is less than start time"
            showAlert.presentAlert(curView: self, title: "Error", message: timeErrorMessage, buttons: messageArr)
        }

    }
    
    func updateNotifications() {
        self.notificationManager.cancelAllNotifications()
        self.notificationManager.createAllNotifications(myTimetable: self.allTimestables)
    }
    
    func deleteCurrrentClass() {
        
        self.database.deleteClass( classID: self.allTimestables[self.dayNo].timetable[self.classRow].id)
        self.deleteClass = true
        self.allTimestables[self.dayNo].timetable[self.classRow].markDeleted = true
        self.updateNotifications()
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindSegue" {
            
            PrintLn.strLine(functionName: "segue", message: "going back")
            if let destinationVC = segue.destination as? DayTableViewController {
                destinationVC.dayTimetable = self.allTimestables
            }
        }
    }

    
    func deleteBreaks() {
        
        if self.allTimestables.count > 0 {
            
            for index in (0...self.allTimestables.count-1).reversed() {
                if self.allTimestables[self.dayNo].timetable[index].id == -1 {
                    print("Delete")
                    print(index)
                    self.allTimestables.remove(at: index)
                }
            }
        }
        
        /*if self.dayTimetable.count > 1 {
         self.checkForBreaks()
         } else {
         self.tableView.reloadData()
         }*/
        
    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath)
//        
//        cell.contentView.backgroundColor = UIColor.black
//        return cell
//    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension EditClassTableViewController {
    
    
    // MARK: UIPickerView DataSource and Delegate Methods
    
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dayPickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let cell = self.tableView.cellForRow(at: indexPathSel!)
        
        cell?.textLabel?.text = self.dayPickerDataSource[row]
        self.dayPicked = false
        self.tableView.reloadData()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dayPickerDataSource[row]
    }
}

extension EditClassTableViewController {
    //MARK: - TextView Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

//MARK : AlertMessageDelegate
extension EditClassTableViewController {
    
    func buttonPressRequest(result: Int) {
        
        
    }
    
}
