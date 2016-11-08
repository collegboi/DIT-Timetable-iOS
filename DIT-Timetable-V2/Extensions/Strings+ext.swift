//
//  Strings+ext.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 08/11/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit


extension String {
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find.lowercased()) != nil
    }
}
