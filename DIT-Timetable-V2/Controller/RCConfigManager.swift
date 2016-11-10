//
//  RCConfigManager.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 03/11/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation
import UIKit

class RCConfigManager {
    
    class func getColor( name: String, defaultColor: UIColor = .black ) -> UIColor {
        
        guard let returnColor = RCFileManager.readJSONColor(keyVal: name) else {
            return defaultColor
        }
        
        return returnColor
    }
    
    class func getTranslation( name: String, defaultName: String = "") -> String {
        
        guard let returnTranslation = RCFileManager.readJSONTranslation(keyName: name) else {
            return defaultName
        }
        
        return returnTranslation
    }
    
    class func getLangugeList() -> [String] {
        
        let returnVal = [String]()
        
        guard let returnTranslation = RCFileManager.readJSONLanuageList() else {
            return returnVal
        }
        
        return returnTranslation
    }
    
    class func getMainSetting(name: String, defaultName: String = "") -> String {
        
        guard let returnSetting = RCFileManager.readJSONMainSettings(keyName: name ) else {
            return defaultName
        }
        
        return returnSetting
    }
    
    class func getObjectProperties( className: String, objectName: String  ) -> [String:AnyObject] {
        
        return RCFileManager.getJSONDict(parseKey: className, keyVal: objectName)
    }
    
    class func checkIfFilesExist() -> Bool {
        
        if RCFileManager.checkFilesExists(fileName: RCFile.readConfigJSON.rawValue)
            && RCFileManager.checkFilesExists(fileName: RCFile.readLangJSON.rawValue) {
            return true
        } else {
            return false
        }
        
    }
    
    
    class func updateConfigFiles() {
        print("updateConfigFiles")
        RCFileManager.changeJSONFileName(oldName: RCFile.saveConfigJSON.rawValue, newName: RCFile.readConfigJSON.rawValue)
        RCFileManager.changeJSONFileName(oldName: RCFile.saveLangJSON.rawValue, newName: RCFile.readLangJSON.rawValue)
    }
    
}
