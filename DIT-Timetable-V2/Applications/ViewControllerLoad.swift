//
//  ViewControllerLoad.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 06/03/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation

protocol ViewControllerLoad { }

extension ViewControllerLoad where Self: UIViewController {
    
    /**
     - parameters:
     - className: put self
     - name: the name of the object instance
     
     */
    func setupViewController( className: UIViewController, _ name: String = "" ) {
        
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
        
        let dict = RCConfigManager.getClassProperties(className: className)
        
        for (key, _) in dict {
            
            switch key {
            case "title":
                self.title =  dict.tryConvert(forKey: key)
                break
            case "backgroundColor":
                self.view.backgroundColor = RCFileManager.readJSONColor(keyVal:  dict.tryConvert(forKey: key) )
                break
           case "isUserInteractionEnabled":
                self.view.isUserInteractionEnabled = dict.tryConvert(forKey: key)
                break
            case "isHidden":
                self.view.isHidden = dict.tryConvert(forKey: key)
                break
        
            default: break
            }
        }
    }
    
}
