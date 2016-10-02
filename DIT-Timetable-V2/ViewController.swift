//
//  ViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 15/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var studentID: UITextField!
    
    @IBOutlet weak var studentPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor(red: 38.0/255, green: 154.0/255, blue: 208.0/255, alpha: 0.5)
        
        /*if PrintLn.readPlistDebugMode() {
            self.studentID.text = "C13720705"
            self.studentPassword.text = "Password1988"
            
            let notificationManager = NotificationManager()
            notificationManager.testModeNotificaitons()
        }*/
        
        self.studentID.delegate = self
        self.studentPassword.delegate = self
        
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
    }
    
    @IBAction func timetableLogin(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ditWebSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ditWebSegue"
        {
            if let destinationVC = segue.destination as? DITWebViewController {
                destinationVC.studentID = self.studentID.text!
                destinationVC.studentPass = self.studentPassword.text!
            }
        }
    }
    //unwind segue function
    @IBAction func unwindToVC(_ segue:UIStoryboardSegue) {
        
    }
    
    //MARK: - TextView Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }


}

