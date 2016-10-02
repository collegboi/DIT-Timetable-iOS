//
//  Integer.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 26/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    
    func randomValue() -> NSObject {
        let randomNum:UInt32 = arc4random_uniform(UInt32(self.count))
        return self[Int(randomNum)] as! NSObject
    }
    
}

extension UIImageView {
    func downloadedFrom( actInd: UIActivityIndicatorView, url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        actInd.startAnimating()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                actInd.stopAnimating()
            }
            }.resume()
    }
    func downloadedFrom(  actInd: UIActivityIndicatorView, link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom( actInd: actInd, url: url, contentMode: mode)
    }
}


extension Date {
    
    func toTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
    }
    
    func hour() -> Int
    {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self as Date)
        return hour
    }
    
    
    func minute() -> Int
    {
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: self as Date)
        return minute
    }
    
    func day() -> Int
    {
        let calendar = Calendar.current
        let minute = calendar.component(.day, from: self as Date)
        return minute
    }
    
    func weekday() -> Int
    {
        let calendar = Calendar.current
        let minute = calendar.component(.weekday, from: self as Date)
        return minute
    }


}


extension String {
    
    func StringTimetoTime( )-> Date {
        
        let today = Date()
        let myCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        var todayComponents = myCalendar.components([.year, .month, .day, .hour, .minute, .second], from: today)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let strDate = dateFormatter.date(from: self)!
        let strDateComp = myCalendar.components([.hour, .minute], from: strDate)
        
        todayComponents.hour = strDateComp.hour
        todayComponents.minute = strDateComp.minute
        return myCalendar.date(from: todayComponents)!
    }
}

