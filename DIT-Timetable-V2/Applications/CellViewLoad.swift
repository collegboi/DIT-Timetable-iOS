//
//  CellViewLoad.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 11/02/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import UIKit

protocol CellViewLoad { }

extension CellViewLoad where Self: UITableViewCell {
    
    func setupLabelView( className: UIViewController, name:String = "" ) {
        self.setup(className: String(describing: type(of: className)), tagValue: name )
    }
    
    func setupLabelView( className: UIView, name:String = "") {
        self.setup(className: String(describing: type(of: className)), tagValue: name)
    }
    
    private func setup( className: String, tagValue : String ) {
        
//        var viewName = tagValue
//        if tagValue.isEmpty {
//            viewName = String(self.tag)
//        }
        
//        let dict = RCConfigManager.getObjectProperties(className: className, objectName: viewName )
//        
//        var fontName: String = ""
//        var size : CGFloat = 0.0
//        for (key, value) in dict {
//            
//            switch key {
//            case "textLabel_text":
//                self.textLabel?.text = value as? String
//                break
//            case "textLabel_BkgdColor":
//                self.textLabel?.backgroundColor = RCFileManager.readJSONColor(keyVal: value as! String)
//                break
//            case "":
//                self.textLabel?.textAlignment =
//            case "backgroundColor":
//                self.backgroundColor = RCFileManager.readJSONColor(keyVal: value as! String)
//                break
//            case "font":
//                fontName = (value as! String)
//                break
//            case "fontSize":
//                size = value as! CGFloat
//                break
//            case "isEnabled":
//                self.isEnabled = ((value as! Int)  == 1) ? true : false
//                break
//            case "isHidden":
//                self.isHidden = ((value as! Int)  == 1) ? true : false
//                break
//            case "isUserInteractionEnabled":
//                self.isUserInteractionEnabled = ((value as! Int)  == 1) ? true : false
//                break
//            default: break
//            }
//        }
//        if !fontName.isEmpty && size > 0.0 {
//            self.font = UIFont(name: fontName, size: size)
//        }
    }
}
