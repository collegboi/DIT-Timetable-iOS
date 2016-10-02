//
//  HelpPageViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 18/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class HelpPageViewController: UIPageViewController {
    
    // Some hard-coded data for our walkthrough screens
    var pageHeaders = [String]()
    // make the status bar white (light content)
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let values = Bundle.contentsOfFile(bundleName: "Settings.plist")
        
        for index in 1...5 {
            let key = "Help"+String(index)
            pageHeaders.append(values[key]! as! String)
        }
    
        // this class is the page view controller's data source itself
        self.dataSource = self
    
        // create the first walkthrough vc
        if let startWalkthroughVC = self.viewControllerAtIndex(0) {
            setViewControllers([startWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigate
    
    func nextPageWithIndex(_ index: Int) {
        if let nextWalkthroughVC = self.viewControllerAtIndex( index+1 ) {
            setViewControllers([nextWalkthroughVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(_ index: Int) -> HelpViewController? {
        
        if index == NSNotFound || index < 0 || index >= self.pageHeaders.count {
            return nil
        }
    
        // create a new walkthrough view controller and assing appropriate date
        if let helpViewController = storyboard?.instantiateViewController(withIdentifier: "HelpViewController") as? HelpViewController {
            helpViewController.imageURL = pageHeaders[index]
            helpViewController.index = index
    
            return helpViewController
        }
    
        return nil
        }
    }
    
extension HelpPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! HelpViewController).index
        index += 1
        return self.viewControllerAtIndex(index)
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! HelpViewController).index
        index -= 1
        return self.viewControllerAtIndex(index)
    }
}

extension HelpPageViewController {
    
    func readFromJSON() -> (Float, Float, Float) {
        print("readFromJSON")
        //print(MyFileManager.readJSONFile(parseKey: "maps", keyVal: "id"))
        return MyFileManager.readJSONColor(parseKey: "navColor", keyVal: "", defaultCode: (38.0, 154.0, 208.0) )
     }
     
     func sendRawTimetable() {
        // Correct url and username/password
        print("sendRawTimetable")
        let values = Bundle.contentsOfFile(bundleName: "Settings.plist")
        let networkURL = values["AppDataURL"]! as! String
        let dic = [String: String]()
        HTTPConnection.httpRequest(params: dic, url: networkURL, httpMethod: "POST") { (succeeded: Bool, data: NSData) -> () in
            // Move to the UI thread
     
            DispatchQueue.main.async {
                if (succeeded) {
                    print("Succeeded")
                    MyFileManager.writeJSONFile(jsonData: data)
                    self.initAppDesign()
                } else {
                    print("Error")
                }
            }
        }
     }
     
     func initAppDesign() {
     
     }
}

