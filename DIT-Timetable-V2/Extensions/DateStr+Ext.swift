//
//  DateStr+Ext.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 31/01/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

extension String {
    
    func convert24HrTo12Hr() -> String {
        
        var resultStr = self
        
        let dateFormatter = DateFormatter()
        let dateFormatter1 = DateFormatter()
        
        let locale = NSLocale.current
        
        let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)!
        
        if dateFormat.localizedStandardContains("a") {
            
            dateFormatter1.dateFormat = "HH:mm"
            if let date12 = dateFormatter1.date(from: self) {
                dateFormatter.dateFormat = "hh:mm a"
                let date22 = dateFormatter.string(from: date12)
                print(date22)
                resultStr = "\(date22)"
                print("output \(time)")
            }
        }

        return resultStr
    }
    
}
