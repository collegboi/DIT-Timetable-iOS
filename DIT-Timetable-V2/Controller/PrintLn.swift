//
//  PrintLn.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 20/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class PrintLn {
    
    class func readPlistDebugMode() -> Bool {
        var debugMode = false
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            debugMode = (dict["debugMode"] != nil)
            debugMode = ( (dict["debugMode"] as! Bool))
        }
        return debugMode
    }
    
    class func strLine ( functionName: String, message: String ) {
     
        #if DEBUG
            print(functionName+": "+message)
        #endif
    }
    
    class func strLine( functionName: String, message : Int ) {
        #if DEBUG
            print(functionName+": "+String(message) )
        #endif
    }
    
    class func strLine( functionName: String, message : Bool ) {
        #if DEBUG
            print(functionName+": "+String(message) )
        #endif
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

class ShowPlainAlert {
    
    class func presentAlert( curView : UIViewController, title: String, message: String, okButton: String = "OK" ) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let buttonAction = UIAlertAction(title: okButton, style: .default, handler: { (action) -> Void in
                
        })
            
        alertController.addAction(buttonAction)

        alertController.popoverPresentationController?.sourceView = curView.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x : curView.view.bounds.size.width / 2.0, y: curView.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        curView.present(alertController, animated: true, completion: nil)
    }
}



class RCNetwork {
    
    class func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

