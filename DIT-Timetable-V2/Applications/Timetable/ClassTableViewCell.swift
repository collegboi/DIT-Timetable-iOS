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
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classTime: UILabel!
    @IBOutlet weak var classLecture: UILabel!
    @IBOutlet weak var classLocation: UILabel!
    @IBOutlet weak var classGroups: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
