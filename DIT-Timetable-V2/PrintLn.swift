//
//  PrintLn.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 20/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation
import UIKit

class PrintLn {
    
    class func readPlistDebugMode() -> Bool {
        var debugMode = false
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            debugMode = (dict["debugMode"] != nil)
            debugMode = ( (dict["debugMode"] as! Int) == 1) ? true : false
        }
        return debugMode
    }
    
    class func strLine ( functionName: String, message: String ) {
     
        if PrintLn.readPlistDebugMode() {
            print(functionName+": "+message)
        }
    }
    
    class func strLine( functionName: String, message : Int ) {
        if PrintLn.readPlistDebugMode() {
            print(functionName+": "+String(message) )
        }
    }
    
    class func strLine( functionName: String, message : Bool ) {
        if PrintLn.readPlistDebugMode() {
            print(functionName+": "+String(message) )
        }
    }
    
}

protocol AlertMessageDelegate {
    func buttonPressRequest(result: Int)
}

class ShowAlert {
    
    var alertDelegate : AlertMessageDelegate?
    
    func presentAlert( curView : UIViewController, title: String, message: String, buttons: [String] ) {
    
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (index, value) in buttons.enumerated() {
        
            let buttonAction = UIAlertAction(title: value, style: .default, handler: { (action) -> Void in
                self.alertDelegate?.buttonPressRequest(result: index)
            })

            alertController.addAction(buttonAction)
        }
        alertController.popoverPresentationController?.sourceView = curView.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x : curView.view.bounds.size.width / 2.0, y: curView.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)

        curView.present(alertController, animated: true, completion: nil)
        
    }
}


