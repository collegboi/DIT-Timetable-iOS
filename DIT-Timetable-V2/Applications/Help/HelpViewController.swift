//
//  HelpViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 18/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var activityIndicator : UIActivityIndicatorView?
    
    //  self.dismiss(animated: true, completion: nil)
    
    // MARK: - Data model for each walkthrough screen
    var index = 0               // the current page index
    var imageURL = ""
    
    // Just to make sure that the status bar is white - it depends on your preference
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator = UIActivityIndicatorView()
        self.activityIndicator!.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        self.activityIndicator!.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        self.activityIndicator!.center = CGPoint(x: self.view.frame.size.width / 2,
                                      y: self.view.frame.size.height / 2);
        
        self.view.addSubview(self.activityIndicator!)
    
        imageView.downloadedFrom( actInd: self.activityIndicator!, link: imageURL)

        pageControl.currentPage = index
    
        startButton.isHidden = (index == 4) ? false : true
        nextButton.isHidden = (index == 5) ? true : false
        startButton.layer.cornerRadius = 5.0
        startButton.layer.masksToBounds = true
    }
    
    @IBAction func startButton(_ sender: AnyObject) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "TimetableHelp")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButton(_ sender: AnyObject) {
        let pageViewController = self.parent as! HelpPageViewController
        pageViewController.nextPageWithIndex(index)
        
    }
    
}
