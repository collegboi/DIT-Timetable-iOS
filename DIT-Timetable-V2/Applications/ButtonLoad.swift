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
    
    func setupButton( className: UIViewController, name: String = "" ) {
        self.setup(className: String(describing: type(of: className)), tagValue: name)
    }
    
    func setupButton( className: UIView, name:String = "" ) {
        self.setup(className: String(describing: type(of: className)), tagValue: name)
    }
    
    private func setup( className: String, tagValue : String ) {
        
        var viewName = ""
        if tagValue.isEmpty {
            viewName = String(self.tag)
        }
        
        let dict = RCConfigManager.getObjectProperties(className: className, objectName: viewName)
        
        var fontName: String = ""
        var size : CGFloat = 0.0
        for (key, value) in dict {
            
            switch key {
            case "title":
                self.setTitle((value as! String), for: .normal)
                break
            case "backgroundColor":
                self.backgroundColor = RCFileManager.readJSONColor(keyVal: value as! String)
                break
            case "fontName":
                fontName = (value as! String)
                break
            case "fontSize":
                size = value as! CGFloat
                break
            case "titleColor":
                self.setTitleColor(RCFileManager.readJSONColor(keyVal: value as! String), for: .normal)
                break
            case "cornerRadius":
                self.layer.cornerRadius = 10
                break
            case "clipsToBounds":
                self.clipsToBounds = ((value as! Int)  == 1) ? true : false
            case "isEnabled":
                self.isEnabled = ((value as! Int)  == 1) ? true : false
                break
            case "isHidden":
                self.isHidden = ((value as! Int)  == 1) ? true : false
                break
            case "isUserInteractionEnabled":
                self.isUserInteractionEnabled = ((value as! Int)  == 1) ? true : false
                break
            default: break
            }
        }
        self.titleLabel!.font = UIFont(name: fontName, size: size)
    }
    
}
