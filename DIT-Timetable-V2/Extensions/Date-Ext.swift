//
//  Date-Ext.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 14/09/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

extension Date {
    
    func toTimeString() -> String {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
    }

    
    func toDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateTimeString = formatter.string(from: self)
        return dateTimeString
    }

    
    func hour() -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self as Date)
        return hour
    }
    
    
    func minute() -> Int {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: self as Date)
        return minute
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        let minute = calendar.component(.day, from: self as Date)
        return minute
    }
    
    func weekday() -> Int {
        let calendar = Calendar.current
        let minute = calendar.component(.weekday, from: self as Date)
        return minute
    }
    
    func weekDayIndex() -> Int {
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: self as Date)
        return (day+5) % 7
    }
    
    
}
