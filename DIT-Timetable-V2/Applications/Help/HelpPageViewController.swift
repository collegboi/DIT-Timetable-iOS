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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //print(values)
        pageHeaders.append("https://timothybarnard.org/images/help/dit_timetable_help.png")
        pageHeaders.append("https://timothybarnard.org/images/help/login_help.png")
        pageHeaders.append("https://timothybarnard.org/images/help/notifications_help.png")
        pageHeaders.append("https://timothybarnard.org/images/help/edit_class_help.png")
        pageHeaders.append("https://timothybarnard.org/images/help/refresh_classes.png")
    
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
    
}

