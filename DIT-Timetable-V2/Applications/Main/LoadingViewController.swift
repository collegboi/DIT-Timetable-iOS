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
    
    var jobLang : Bool = false
    var jobConfig : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.checkViewControllerToLoad()
        }
    }
    
    
    func checkViewControllerToLoad() {
        
        
        PrintLn.strLine(functionName: "checkViewControllerToLoad", message: 1)
        let database = Database()
        
        let userDefaults = UserDefaults.standard
        let TimetableHelp = userDefaults.bool(forKey: "TimetableHelp")
        
        // if we haven't shown the walkthroughs, let's show them
        if !TimetableHelp {
            PrintLn.strLine(functionName: "checkViewControllerToLoad", message: 2)
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
               PrintLn.strLine(functionName: "checkViewControllerToLoad", message: 3)
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
                PrintLn.strLine(functionName: "checkViewControllerToLoad", message: 4)
                self.performSegue(withIdentifier: "mainVCSegue", sender: self)
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
    
}

