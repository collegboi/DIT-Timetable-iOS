//
//  DetailClassViewController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 24/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class DetailClassViewController: UIViewController {

    @IBOutlet weak var moduleName: UILabel!
    @IBOutlet weak var moduleTIme: UILabel!
    @IBOutlet weak var moduleRoom: UILabel!
    @IBOutlet weak var moduleLecture: UILabel!
    @IBOutlet weak var moduleGroup: UILabel!
    
    var name:String = ""
    var time:String = ""
    var room:String = ""
    var lecture:String = ""
    var group:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moduleName.text = self.name
        self.moduleTIme.text = self.time
        self.moduleRoom.text = self.room
        self.moduleLecture.text = self.lecture
        self.moduleGroup.text = self.group

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
