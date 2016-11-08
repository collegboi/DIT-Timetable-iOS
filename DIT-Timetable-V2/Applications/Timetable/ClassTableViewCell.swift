//
//  ClassTableViewCell.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 17/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell {

    @IBOutlet weak var currentClass: UIView!
    @IBOutlet weak var className: LabelView!
    @IBOutlet weak var classTime: LabelView!
    @IBOutlet weak var classLecture: LabelView!
    @IBOutlet weak var classLocation: LabelView!
    @IBOutlet weak var classGroups: LabelView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.currentClass.setupLabelView(className: self, name: "currentClass")
        self.className.setupLabelView(className: self, name: "className")
        self.classTime.setupLabelView(className: self, name: "classTime")
        self.classLecture.setupLabelView(className: self, name: "classLecture")
        self.classLocation.setupLabelView(className: self, name: "classLocation")
        self.classGroups.setupLabelView(className: self, name: "classGroups")
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
