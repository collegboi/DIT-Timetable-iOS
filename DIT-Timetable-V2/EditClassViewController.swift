//
//  EditClassViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 17/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit
import RealmSwift


class EditClassViewController: UIViewController, UITextFieldDelegate, AlertMessageDelegate {

    @IBOutlet weak var moduleName: UILabel!
    @IBOutlet weak var classLecture: UITextField!
    @IBOutlet weak var classRoom: UITextField!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var classGroups: UITextField!
    
    @IBOutlet weak var toggleNotifications: UISwitch!
    
    //var currentClass = Timetable()
    var allTimestables = [AllTimetables]()
    var dayNo : Int = 0
    var updateDayNo : Int = 0
    
    var notifOn : Int = 1
    let database = Database()
    let notificationManager = NotificationManager()
    var classRow : Int = 0
    var deleteClass : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.classLecture.delegate = self
        self.classRoom.delegate = self
        self.classGroups.delegate = self
        //self.deleteBreaks()
        
        let myClass = self.database.getClass(classID: self.allTimestables[self.dayNo].timetable[self.classRow].id)
        self.updateDayNo = self.dayNo
        
        if myClass.notifOn == 1 {
            self.toggleNotifications.isOn = true
        } else {
            self.toggleNotifications.isOn = false
        }
        
        self.moduleName.text = self.allTimestables[self.dayNo].timetable[self.classRow].name
        self.classLecture.text = self.allTimestables[self.dayNo].timetable[self.classRow].lecture
        self.classRoom.text = self.allTimestables[self.dayNo].timetable[self.classRow].room
        self.classGroups.text = self.allTimestables[self.dayNo].timetable[self.classRow].groups
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateStart = dateFormatter.date(from: self.allTimestables[self.dayNo].timetable[self.classRow].timeStart)
        let dateEnd = dateFormatter.date(from: self.allTimestables[self.dayNo].timetable[self.classRow].timeEnd)
        
        self.startTime.date = dateStart!
        self.endTime.date = dateEnd!

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleNotifications(_ sender: AnyObject) {
        
        if self.toggleNotifications.isOn {
            self.notifOn = 1
            self.notificationManager.removeANotification(notificaitonID: self.allTimestables[self.dayNo].timetable[self.classRow].id)
        } else {
            self.notifOn = 0
            self.notificationManager.createNotification(myTimetable: self.allTimestables[self.dayNo].timetable[self.classRow])
        }
    }

    
    
    //MARK: - TextView Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func saveClass(_ sender: AnyObject) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if self.startTime.date < self.endTime.date {
        
            self.allTimestables[self.dayNo].timetable[self.classRow].lecture = self.classLecture.text!
            self.allTimestables[self.dayNo].timetable[self.classRow].room = self.classRoom.text!
            self.allTimestables[self.dayNo].timetable[self.classRow].groups = self.classGroups.text!
            self.allTimestables[self.dayNo].timetable[self.classRow].timeStart = dateFormatter.string(from: self.startTime.date)
            self.allTimestables[self.dayNo].timetable[self.classRow].timeEnd = dateFormatter.string(from: self.endTime.date)
            self.allTimestables[self.dayNo].timetable[self.classRow].notifOn = self.notifOn
            self.allTimestables[self.dayNo].timetable[self.classRow].name = self.moduleName.text!
            self.allTimestables[self.dayNo].timetable[self.classRow].dayNo = self.updateDayNo
        
            self.database.updateTimetable(timetable: self.allTimestables[self.dayNo].timetable[self.classRow])
        
            self.updateNotifications()
        
            //self.updateClass = true
        
            self.performSegue(withIdentifier: "unwindSegue", sender: self)
        } else {
            let showAlert = ShowAlert()
            showAlert.alertDelegate = self
            let messageArr = ["OK"]
            showAlert.presentAlert(curView: self, title: "Error", message: "End time is less than start time", buttons: messageArr)
        }
        
    }
    
    func updateNotifications() {
        self.notificationManager.cancelAllNotifications()
        self.notificationManager.createAllNotifications(myTimetable: self.allTimestables)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "unwindSegue" {
        
            PrintLn.strLine(functionName: "segue", message: "going back")
            if let destinationVC = segue.destination as? DayTableViewController {
                destinationVC.dayTimetable = self.allTimestables
                PrintLn.strLine(functionName: "segue Edit", message: self.allTimestables.count)
                PrintLn.strLine(functionName: "segue Edit1", message: destinationVC.dayTimetable.count)
            }
        }
    }

    
    @IBAction func deleteClass(_ sender: AnyObject) {
        
        self.database.deleteClass( classID: self.allTimestables[self.dayNo].timetable[self.classRow].id)
        self.deleteClass = true
        self.allTimestables[self.dayNo].timetable[self.classRow].markDeleted = true
        self.updateNotifications()
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
        
    }
    
    @IBAction func changeDay(_ sender: AnyObject) {
        self.addAlertSheet()
    }
    
    func addAlertSheet() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let buttonMon = UIAlertAction(title: "Monday", style: .default, handler: { (action) -> Void in
            self.changeClassDay(dayNo: 0)
        })
        let buttonTues = UIAlertAction(title: "Tuesday", style: .default, handler: { (action) -> Void in
            self.changeClassDay(dayNo: 1)
        })
        let buttonWed = UIAlertAction(title: "Wednesday", style: .default, handler: { (action) -> Void in
            self.changeClassDay(dayNo: 2)
        })
        let buttonThurs = UIAlertAction(title: "Thursday", style: .default, handler: { (action) -> Void in
            self.changeClassDay(dayNo: 3)
        })
        let buttonFri = UIAlertAction(title: "Friday", style: .default, handler: { (action) -> Void in
            self.changeClassDay(dayNo: 4)
        })
        let buttonSat = UIAlertAction(title: "Saturday", style: .default, handler: { (action) -> Void in
            self.changeClassDay(dayNo: 5)
        })
        let buttonSun = UIAlertAction(title: "Sunday", style: .default, handler: { (action) -> Void in
            self.changeClassDay(dayNo: 6)
        })
        let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }
        alertController.addAction(buttonMon)
        alertController.addAction(buttonTues)
        alertController.addAction(buttonWed)
        alertController.addAction(buttonThurs)
        alertController.addAction(buttonFri)
        alertController.addAction(buttonSat)
        alertController.addAction(buttonSun)
        alertController.addAction(buttonCancel)
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x : self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func changeClassDay(dayNo : Int) {
        PrintLn.strLine(functionName: "changeClassDay", message: dayNo)
        self.allTimestables[self.dayNo].timetable[self.classRow].dayNo = dayNo
        self.allTimestables[self.dayNo].timetable[self.classRow].markDeleted = true
        self.updateDayNo = dayNo
        
        let classChange = Timetable()
        classChange.id = self.allTimestables[self.dayNo].timetable[self.classRow].id
        classChange.groups = self.allTimestables[self.dayNo].timetable[self.classRow].groups
        classChange.lecture = self.allTimestables[self.dayNo].timetable[self.classRow].lecture
        classChange.name = self.allTimestables[self.dayNo].timetable[self.classRow].name
        classChange.notifOn = self.allTimestables[self.dayNo].timetable[self.classRow].notifOn
        classChange.timeStart = self.allTimestables[self.dayNo].timetable[self.classRow].timeStart
        classChange.timeEnd = self.allTimestables[self.dayNo].timetable[self.classRow].timeEnd
        classChange.weeks = self.allTimestables[self.dayNo].timetable[self.classRow].weeks
        classChange.markDeleted = false
        classChange.dayNo = dayNo
        self.allTimestables[dayNo].timetable.append(classChange)
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
    
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

}
//MARK : AlertMessageDelegate
extension EditClassViewController {
    
    func buttonPressRequest(result: Int) {
        
        
    }
    
}
