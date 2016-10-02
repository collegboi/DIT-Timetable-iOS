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
        
        // Get the document directory url
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
            print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            print("mp3 list:", mp3FileNames)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if let path = Bundle.main.path(forResource: "stringsFile", ofType: "json")
        {
            print("stringsFile located")
            if let jsonData = NSData(contentsOfFile: path)   //  NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)
            {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as! [String:Any]
                
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
        }
        return returnStr
    }
    
    class func writeJSONFile( jsonData : NSData ) {
        
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = NSURL(string: documentsDirectoryPathString)!
        // Write that JSON to the file created earlier
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("stringsFile.json")
        do {
            let file = try FileHandle(forWritingTo: jsonFilePath!)
            file.write(jsonData as Data)
            print("JSON data was written to teh file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
    }
}
