//
//  ButtonLoad.swift
//  Remote Config
//
//  Created by Timothy Barnard on 23/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

protocol ButtonLoad { }

extension ButtonLoad where Self: UIButton {
    
    /**
     - parameters:
        - className: put self
        - name: the name of the object instance
     
     */
    mutating func setupButton( className: UIViewController, _ name: String = "" ) {
        
        self.setup(className: String(describing: type(of: className)), tagValue: name)
    }
    
    /**
     - parameters:
     - className: put self
     - name: the name of the object instance
     
     */
    func setupButton( className: UIView, _ name:String = "" ) {
        self.setup(className: String(describing: type(of: className)), tagValue: name)
    }
    
    func setup( className: String, tagValue : String ) {
    
        
        var viewName = ""
        if tagValue.isEmpty {
            viewName = String(self.tag)
        }
        
        let dict = RCConfigManager.getObjectProperties(className: className, objectName: viewName)
        
        var fontName: String = ""
        var size : CGFloat = 0.0
        for (key, _) in dict {
            
            switch key {
            case "title":
                self.setTitle( dict.tryConvert(forKey: key) , for: .normal)
                break
            case "backgroundColor":
                self.backgroundColor = RCFileManager.readJSONColor(keyVal:  dict.tryConvert(forKey: key) )
                break
            case "fontName":
                fontName = dict.tryConvert(forKey: key)
                break
            case "fontSize":
                size = dict.tryConvert(forKey: key)
                break
            case "titleColor":
                self.setTitleColor(RCFileManager.readJSONColor(keyVal: dict.tryConvert(forKey: key)), for: .normal)
                break
            case "cornerRadius":
                self.layer.cornerRadius = 10
                break
            case "clipsToBounds":
                self.clipsToBounds = dict.tryConvert(forKey: key)
            case "isEnabled":
                self.isEnabled = dict.tryConvert(forKey: key)
                break
            case "isHidden":
                self.isHidden = dict.tryConvert(forKey: key)
                break
            case "isUserInteractionEnabled":
                self.isUserInteractionEnabled = dict.tryConvert(forKey: key)
                break
            default: break
            }
        }
        
        if fontName != "" && size != 0.0 {
            self.titleLabel!.font = UIFont(name: fontName, size: size)
        }
    }
    
}
