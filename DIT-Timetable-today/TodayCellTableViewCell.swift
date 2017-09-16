//
//  TodayCellTableViewCell.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 14/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit

class TodayCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classStartTime: UILabel!
    @IBOutlet weak var lectureName: UILabel!
    

    func setupCell(timetable: Timetable) {
        
        self.className.text = timetable.name
        self.classStartTime.text = timetable.timeStart.convertToCurrentTimeFormat()
        self.lectureName.text = timetable.room
    }

}
