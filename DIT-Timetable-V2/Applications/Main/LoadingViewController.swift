//
//  LoadingViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 03/11/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    
    let queue = DispatchQueue(label: "com.barnard.dispatchgroup", attributes: .concurrent, target: .main)
    let group = DispatchGroup()
    
    var jobLang : Bool = false
    var jobConfig : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !RCConfigManager.checkIfFilesExist() {
            
            self.getRemoteConfigFiles()
            self.getRemoteLangFiles()
            
        } else {
            checkVersionFile()
        }
        
        group.notify(queue: DispatchQueue.main) {
            //self.checkBothJobs()
            //print("done")
        }
        
    }
    
    func checkBothJobs() {
        //print("here")
        //print(self.jobConfig, self.jobLang)
        if jobLang && jobConfig {
            
            //print(RCConfigManager.getMainSetting(name: "url"))
            //print(RCConfigManager.getTranslation(name: "greeting"))
            self.checkViewControllerToLoad()
        }
        
    }
    
    func setupNavigationBar() {
        
        let navColor = self.readFromJSON()
        UINavigationBar.appearance().barTintColor = navColor
    }
    
    func checkViewControllerToLoad() {
        
        self.setupNavigationBar()
        
        print("1")
        let database = Database()
        
        let userDefaults = UserDefaults.standard
        let TimetableHelp = userDefaults.bool(forKey: "TimetableHelp")
        
        // if we haven't shown the walkthroughs, let's show them
        if !TimetableHelp {
            print("2")
            self.performSegue(withIdentifier: "showHelpSegue", sender: self)
            
            /*self.window = UIWindow(frame: UIScreen.main.bounds)
            
            var storyboard = UIStoryboard()
            
            if ( UIDevice.current.userInterfaceIdiom == .pad  ) {
                storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
            } else {
                storyboard = UIStoryboard(name: "Main", bundle: nil)
            }
            
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HelpPageViewController")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()*/
            
        } else {
            
            if database.getSavedClassesCount() == 0 {
               print("3")
                self.performSegue(withIdentifier: "loginVCSegue", sender: self)
                
                /*self.window = UIWindow(frame: UIScreen.main.bounds)loginVCSegue
                
                var storyboard = UIStoryboard()
                
                if ( UIDevice.current.userInterfaceIdiom == .pad  ) {
                    storyboard = UIStoryboard(name: "StoryboardiPad", bundle: nil)
                } else {
                    storyboard = UIStoryboard(name: "Main", bundle: nil)
                }
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()*/
            } else {
                print("4")
                self.performSegue(withIdentifier: "mainVCSegue", sender: self)
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "mainViewSegue"
        //{
            //if let destinationVC = segue.destination as? ViewController {
            
            //}
        //}
    }
    
    func getRemoteConfigFiles() {
        // Correct url and username/password
        
        print("sendRawTimetable")
        let networkURL = "https://timothybarnard.org/Scrap/appDataRequest.php"
        let dic = [String: String]()
        HTTPConnection.httpRequest(params: dic, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            self.group.enter()
            self.queue.async {
                if (succeeded) {
                    //print("Succeeded")
                    RCFileManager.writeJSONFile(jsonData: data, fileType: .config)
                    self.jobConfig = true
                    self.group.leave()
                    self.checkBothJobs()
                } else {
                    print("Error")
                }
            }
        }
    }
    
    func getRemoteLangFiles() {
        // Correct url and username/password
        var langugage = UserDefaults.standard.value(forKey: "language") as? String
        
        if langugage == nil {
            langugage = "English"
        }
        
        print("sendRawTimetable")
        let networkURL = "https://timothybarnard.org/Scrap/appDataRequest.php?type=translation&language="+langugage!
        let dic = [String: String]()
        HTTPConnection.httpRequest(params: dic, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            self.group.enter()
            self.queue.async {
                if (succeeded) {
                    //print("Succeeded")
                    RCFileManager.writeJSONFile(jsonData: data, fileType: .language)
                    self.jobLang = true
                    self.group.leave()
                    self.checkBothJobs()
                } else {
                    print("Error")
                }
            }
        }
    }
    
    func checkVersionFile() {
        
        var returnVal = false
        
        print("gettingverison")
        
        let networkURL = "https://timothybarnard.org/Scrap/appDataCheck.php"
        let dic = [String: String]()
        HTTPConnection.httpRequest(params: dic, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
            
            DispatchQueue.main.async {
                if (succeeded) {
                    //print("Succeeded")
                    let values = HTTPConnection.parseJSONDic(data: data)
                    if values?["update"] as? Int ?? 0 == 1  {
                        print("true")
                        returnVal = true
                    }
                    
                    if returnVal {
                        
                        self.getRemoteConfigFiles()
                        self.getRemoteLangFiles()
                        
                    } else {
                        self.checkViewControllerToLoad()
                    }
                    
                } else {
                    print("Error")
                }
            }
        }
    }
    
    func readFromJSON() -> UIColor {
        //print("readFromJSON")
        //print(MyFileManager.readJSONFile(parseKey: "maps", keyVal: "id"))
        let defaultColor = UIColor(red: 38/255, green: 154/255, blue: 208/255, alpha: 1)
        return RCConfigManager.getColor(name: "navColor", defaultColor: defaultColor)
    }

    
    
}

