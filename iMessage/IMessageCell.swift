//
//  IMessageCell.swift
//  iMessage
//
//  Created by Timothy Barnard on 24/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation
import UIKit

class IMessageCell: UITableViewCell {
    
    @IBOutlet weak var currentClass: UIView!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classTime: UILabel!
    @IBOutlet weak var classLecture: UILabel!
    @IBOutlet weak var classLocation: UILabel!
    @IBOutlet weak var classGroups: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
