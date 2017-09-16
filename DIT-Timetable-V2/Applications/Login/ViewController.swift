//
//  ViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 15/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class ViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var lanaugeButton: UIButton!
    
    @IBOutlet weak var studentID: UITextField!
    
    @IBOutlet weak var studentPassword: UITextField!
    
    @IBOutlet weak var timetableLogin: UIButton!
    
    var langaugeList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 44.0/255, green: 153.0/255, blue: 206.0/255, alpha: 1)
        
        /*if PrintLn.readPlistDebugMode() {
            self.studentID.text = "C13720705"
            self.studentPassword.text = "Password1988"
            
            let notificationManager = NotificationManager()
            notificationManager.testModeNotificaitons()
        }*/
        
        self.studentID.delegate = self
        self.studentPassword.delegate = self
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func timetableLogin(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "ditWebSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ditWebSegue" {
            if let destinationVC = segue.destination as? DITWebViewController {
                destinationVC.studentID = self.studentID.text!
                destinationVC.studentPass = self.studentPassword.text!
            }
        } else if segue.identifier == "helpView" {
            print("going to helpview")
        }
    }
    //unwind segue function
    @IBAction func unwindToVC(_ segue:UIStoryboardSegue) {
        
    }
    @IBAction func helpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "helpView", sender: self)
    }
    
    @IBAction func feedbackButton(_ sender: Any) {
        
        var versioNo = "Version no: Unknown"
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versioNo = "Version no: " + version
        }
        
        let date = Date()
        let dateString = date.toDateTimeString()
        let deviceName = UIDevice.current.modelName

        let body = "Device: " + deviceName + " <> " + versioNo + " <> " + dateString
        
        let alert = UIAlertController(title: "Feedback", message: "Fill in your student id and comments", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Student ID"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Comments..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            
            if let textFields = alert?.textFields {
                if textFields.count > 1 {
                    
                    guard let studentID = textFields[0].text else {
                        return
                    }
                    
                    guard let comments = textFields[1].text else {
                        return
                    }
                    
                    let text = "Student ID: " + studentID + " <> Comments: " + comments + "<>" + body
                    HTTPConnection.getRequest(text: text)
                    
                    let alert = UIAlertController(title: "", message:"Thank you for your feedback.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { _ in
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true){
                    }
                }
                
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TextView Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func addAlertSheet(_ sender: UIButton  ) {

        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        for (index, language ) in self.langaugeList.enumerated() {
        
            let langAction = UIAlertAction(title: language, style: .default, handler: { (action) -> Void in
                self.getDiffLanguage(index: index)
            })
            
            alertController.addAction(langAction)
        }
        
        let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }
        
        alertController.addAction(buttonCancel)
    
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = sender.frame //CGRect(x : self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func getDiffLanguage( index: Int ) {
        
        if RCNetwork.isInternetAvailable() {
            self.getRemoteLangFiles(language: self.langaugeList[index])
        } else {
            let error = "Error"
            let noInternet = "No internet connection"
            ShowPlainAlert.presentAlert(curView: self, title: error, message: noInternet )
        }
        
    }
    
    func getRemoteLangFiles( language: String )  {
        // Correct url and username/password
        self.timetableLogin.isEnabled = false
        print("sendRawTimetable")
        let networkURL = "https://timothybarnard.org/Scrap/appDataRequest.php?type=translation&language="+language
        let dic = [String: String]()
        HTTPConnection.httpRequest(params: dic, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    //print("Succeeded")
                    RCFileManager.writeJSONFile(jsonData: data, fileType: .language)
                    
                    UserDefaults.standard.setValue(language, forKey: "language")
                    
                } else {
                    print("Error")
                }
                self.timetableLogin.isEnabled = true
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}

