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

    
    @IBOutlet weak var lanaugeButton: UIButton!
    
    @IBOutlet weak var studentID: UITextField!
    
    @IBOutlet weak var studentPassword: UITextField!
    
    @IBOutlet weak var timetableLogin: Button!
    
    var langaugeList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timetableLogin.setupButton(className: self, "timetableLogin")
        
        self.langaugeList = RCConfigManager.getLangugeList()
        
        if self.langaugeList.count > 0 {
            self.lanaugeButton.addTarget(self, action: #selector(self.addAlertSheet), for: .touchUpInside)
        }
        
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
        TBAnalyitcs.send(self)
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
    
    func addAlertSheet(_ sender: UIButton  ) {
        TBAnalyitcs.send(self)
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
            let error = RCConfigManager.getTranslation(name: "error", defaultName: "Error")
            let noInternet = RCConfigManager.getTranslation(name: "noInternet", defaultName: "No internet connection")
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

}

