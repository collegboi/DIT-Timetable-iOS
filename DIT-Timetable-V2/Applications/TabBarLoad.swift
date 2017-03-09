//
//  TabBarLoad.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 08/03/2017.
//  Copyright © 2017 Timothy Barnard. All rights reserved.
//

import Foundation


protocol TabBarLoad { }

struct RCTabItem: JSONSerializable {
    
    var title:String!
    var image:String!
    var tag:Int!
    
    init(title:String, image:String, tag:Int) {
        self.title = title
        self.image = image
        self.tag = tag
    }
    
    init(dict: String) {}
    init(dict: [String]) {}
    init() {}
    
    init(dict: [String : Any]) {
        self.title = dict.tryConvert(forKey: "title")
        self.image = dict.tryConvert(forKey: "image")
        self.tag = dict.tryConvert(forKey: "tag")
    }
}


extension TabBarLoad where Self: UITabBarController {
    
    /**
     - parameters:
     - className: put self
     - name: the name of the object instance
     
     */
    func setupTabBar( className: UIViewController, _ name: String = "" ) {
        
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
        
        let dict = RCConfigManager.getObjectProperties(className: className, objectName: tagValue)
        
        for (key, value) in dict {
            
            switch key {
                case "tabBarItems":
                    
                    self.tabBar.items?.removeAll()
                
                    guard let tabBarItems = value as? [Any] else {
                        return
                    }
                    
                    for tabBarItemObj in tabBarItems {
                        
                        guard let tabBarDic = tabBarItemObj as? [String:Any] else {
                            return
                        }
                        
                        let rcTabBarItem = RCTabItem(dict: tabBarDic)
                        
                        let tabBarItem = UITabBarItem(title: rcTabBarItem.title,
                                                      image: UIImage(named:rcTabBarItem.image),
                                                      tag: rcTabBarItem.tag)
                        
                        self.tabBar.items?.append(tabBarItem)
                    }
                break
                case "backgroundColor":
                    self.view.backgroundColor = RCFileManager.readJSONColor(keyVal:  dict.tryConvert(forKey: key) )
                break
                
            default: break
            }
        }
    }
    
}
