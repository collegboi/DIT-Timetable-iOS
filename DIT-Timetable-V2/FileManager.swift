//
//  FileManager.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 22/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation

class MyFileManager {
    
    class func readJSONFile( parseKey : String, keyVal : String ) -> String {
        
        var returnStr = ""
        let file = File.readJSON
        
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first,
            let path = NSURL(fileURLWithPath: dir).appendingPathComponent(file.rawValue) {
            
            let jsonData = NSData(contentsOf: path) // NSString(contentsOf: path, encoding: String.Encoding.utf8.rawValue)
            
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: jsonData as! Data, options: .allowFragments) as! [String:Any]
                
                   if let classes = parsedData[parseKey] as? NSArray {
                        
                        for data in classes {
                            print(data)
                            let curData = data as! [String:Any]
                            returnStr = curData[keyVal] as! String
                        }
                    }
                
                } catch let error as NSError {
                    print(error)
                }
            }
        return returnStr
    }
    
    class func readJSONColor( parseKey : String, keyVal : String, defaultCode: (Float, Float, Float) ) -> (Float, Float, Float) {
        
        let returnStr = defaultCode
        /*let file = File.readJSON
        
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first,
            let path = NSURL(fileURLWithPath: dir).appendingPathComponent(file.rawValue) {
            
            let jsonData = NSData(contentsOf: path) // NSString(contentsOf: path, encoding: String.Encoding.utf8.rawValue)
            
            do {
                //let parsedData = try JSONSerialization.jsonObject(with: jsonData as! Data, options: .allowFragments) as! [String:Any]
                
                //if let classes = parsedData[parseKey] as? [String:String] {
                 //   returnStr = ( Float(classes["red"]!)!, Float(classes["green"]!)!, Float(classes["blue"]!)! )
                //}
                
            } catch let error as NSError {
                print(error)
            }
        }*/
        return returnStr
    }

    class func writeJSONFile( jsonData : NSData ) {
        
        let file = File.saveJSON
        
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first,
            let path = NSURL(fileURLWithPath: dir).appendingPathComponent(file.rawValue) {
            
            //writing
            do {
                try jsonData.write(to: path, options: .noFileProtection) //text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
        }
        
        /*let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        // Write that JSON to the file created earlier
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("stringsFile.json")
        
        let filemgr = FileManager.default
        
        do {
            print(jsonFilePath)
            //let file = try FileHandle(forWritingTo: jsonFilePath!)
            //file.write(jsonData as Data)
            filemgr.createFile(atPath: "/var/mobile/Containers/Data/Application/5B01763D-D2D9-42BE-87C4-BA9FF8E01201/Documents/stringsFile.json", contents: jsonData as Data, attributes: nil)
            print("JSON data was written to the file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }*/
    }
}
