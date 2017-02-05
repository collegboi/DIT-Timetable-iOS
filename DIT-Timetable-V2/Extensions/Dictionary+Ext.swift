//
//  AnyObject+Ext.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 10/11/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit


extension Dictionary {
    
    func tryConvert(forKey key:Key, defaultVal :String = "" ) -> String {
        
        guard let test = self[key] as? String else {
            return defaultVal
        }
        return test
    }
    
    func tryConvert(forKey key:Key, defaultVal :Int = 0 ) -> Int {
        
        guard let test = self[key] as? Int else {
            return defaultVal
        }
        return test
    }
    
    func tryConvert(forKey key:Key, defaultVal :Float = 0 ) -> Float {
        
        guard let test = self[key] as? Float else {
            return defaultVal
        }
        return test
    }
    
    func tryConvert(forKey key:Key, defaultVal :CGFloat = 0 ) -> CGFloat {
        
        guard let test = self[key] as? CGFloat else {
            return defaultVal
        }
        return test
    }
    
    
    func tryConvert(forKey key:Key, defaultVal :Bool = false ) -> Bool {
        
        guard let test = self[key] as? Int else {
            return defaultVal
        }
        return (test  == 1) ? true : false
    }
    
    func tryConvert(forKey key:Key, defaultVal :Double = 0 ) -> Double {
        
        guard let test = self[key] as? Double else {
            return defaultVal
        }
        return test
    }
}
