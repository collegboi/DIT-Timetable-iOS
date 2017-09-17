//
//  ClassRowController.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 16/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import WatchKit

class ClassRowController: NSObject {
    
    @IBOutlet var separator: WKInterfaceSeparator!
    @IBOutlet var moduleNameLabel: WKInterfaceLabel!
    @IBOutlet var timeStartLabel: WKInterfaceLabel!
    @IBOutlet var roomLabel: WKInterfaceLabel!
    

    var timetable: Timetable? {

        didSet {

            guard let timetable = timetable else { return }

            moduleNameLabel.setText(timetable.name)
            timeStartLabel.setText(timetable.timeStart)
            roomLabel.setText(timetable.room)
        }
    }

}
