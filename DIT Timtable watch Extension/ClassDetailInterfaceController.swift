//
//  ClassDetailInterfaceController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 17/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import WatchKit
import Foundation


class ClassDetailInterfaceController: WKInterfaceController {

    @IBOutlet var moduleNameLabel: WKInterfaceLabel!
    @IBOutlet var lectureLabel: WKInterfaceLabel!
    @IBOutlet var timeStartLabel: WKInterfaceLabel!
    @IBOutlet var timeEndLabel: WKInterfaceLabel!
    @IBOutlet var roomLabel: WKInterfaceLabel!
    
    
    var timetable: Timetable? {
    
        didSet {
    
            guard let timetable = timetable else { return }
     
            moduleNameLabel.setText(timetable.moduleName)
            lectureLabel.setText(timetable.lecture)
            timeStartLabel.setText(timetable.timeStart.convertToCurrentTimeFormat())
            timeEndLabel.setText(timetable.timeEnd.convertToCurrentTimeFormat())
            roomLabel.setText(timetable.room)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let timetable = context as? Timetable {
            self.timetable = timetable
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
