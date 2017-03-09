//
//  ViewLoad.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 07/03/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

protocol ViewLoad { }



extension ViewLoad where Self: UIView {
    
    /**
     - parameters:
     - className: put self
     - name: the name of the object instance
     
     */
    func setupView( className: UIView, _ name: String = "" ) {
        
        self.setup(className: String(describing: type(of: className)), tagValue: name)
    }
    
    /**
     - parameters:
     - className: put self
     - name: the name of the object instance
     
     */
    //    func setupViewController( className: UIView, _ name:String = "" ) {
    //        self.setup(className: String(describing: type(of: className)), tagValue: name)
    //    }
    
    func setup( className: String, tagValue : String ) {
        
        let dict = RCConfigManager.getObjectProperties(className: className, objectName: tagValue)
        
        for (key, _) in dict {
            
            switch key {
            case "backgroundColor":
                self.backgroundColor = RCFileManager.readJSONColor(keyVal:  dict.tryConvert(forKey: key) )
                break
            case "isUserInteractionEnabled":
                self.isUserInteractionEnabled = dict.tryConvert(forKey: key)
                break
            case "isHidden":
                self.isHidden = dict.tryConvert(forKey: key)
                break
                
            default: break
            }
        }
    }
    
}
