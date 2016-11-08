//
//  ImageLoad.swift
//  Remote Config
//
//  Created by Timothy Barnard on 23/10/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import UIKit

protocol ImageLoad {}

extension ImageLoad where Self: UIImageView {
    
    func setupImageView( className: UIViewController, name: String = "" ) {
        self.setup(className: String(describing: type(of: className)), tagValue: name )
    }
    
    
    func setupImageView( className: UIView, name: String = "") {
        self.setup(className: String(describing: type(of: className)), tagValue: name)
    }
    
    private func setup( className: String, tagValue : String ) {
        
        var viewName = tagValue
        if tagValue.isEmpty {
            viewName = String(self.tag)
        }
        
        let dict = RCConfigManager.getObjectProperties(className: className, objectName: viewName )
        
        for (key, value) in dict {
            switch key {
            case "image":
                self.image = UIImage(named: value as! String)
                break
            case "contentMode":
                self.contentMode = UIViewContentMode(rawValue: (value as! Int))!
            case "isHidden":
                self.isHidden = ((value as! Int)  == 1) ? true : false
                break
            case "isUserInteractionEnabled":
                self.isUserInteractionEnabled = ((value as! Int)  == 1) ? true : false
                break
            default: break
            }
        }
    }
    
    
}
