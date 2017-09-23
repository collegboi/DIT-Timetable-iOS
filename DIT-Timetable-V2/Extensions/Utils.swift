//
//  Utils.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 16/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation


class Utils {
    
    class func using12hClockFormat() -> Bool {
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        let dateString = formatter.string(from: Date())
        let amRange = dateString.range(of: formatter.amSymbol)
        let pmRange = dateString.range(of: formatter.pmSymbol)
        
        return !(pmRange == nil && amRange == nil)
    }
    
    class func create12HourTo24HourStr(time: String) -> String {
        
        let timeParts1 = time.components(separatedBy: " ")
        if(timeParts1.count >= 2) {
            
            let amPM = timeParts1[1]
            let timePart = timeParts1[0]
            
            let timeParts = timePart.components(separatedBy: ":")
            if(timeParts.count == 2) {
                
                guard let hour = Int(timeParts[0]) else {
                    return time
                }
                guard let min = Int(timeParts[1]) else {
                    return time
                }
                
                var newHour = hour
                if(amPM.lowercased() == "p.m.") {
                    newHour = hour + 12
                }
                
                return String(newHour) + ":" + String(min)
                
                
            } else {
                return time
            }

            
            
        } else {
            return time
        }
    }

    
    
    class func create12HourTimeStr(time: String, showAMPM: Bool = true) -> String {
        let timeParts = time.components(separatedBy: ":")
        if(timeParts.count == 2) {
            
            guard let hour = Int(timeParts[0]) else {
                return time
            }
            guard let min = Int(timeParts[1]) else {
                return time
            }
            
            var amPM: String = "a.m."
            
            if(hour > 12) {
                amPM = "p.m."
            }
            
            var newHour = 12
            if(hour != 12) {
                newHour = hour % 12
            }
            
            var newMinString = String(min)
            if(min < 10) {
                newMinString = "0" + String(min)
            }
            
            if(showAMPM) {
                return String(newHour) + ":" + newMinString + " " + amPM
            } else {
                return String(newHour) + ":" + newMinString
            }
            
        } else {
            return time
        }
    }
}
