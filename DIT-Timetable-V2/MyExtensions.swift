//
//  Integer.swift
//  DIT-Timetable-V2
//
//  Created by Timothy Barnard on 26/09/2016.
//  Copyright © 2016 Timothy Barnard. All rights reserved.
//

import Foundation

extension Array {
    
    func randomValue() -> NSObject {
        let randomNum:UInt32 = arc4random_uniform(UInt32(self.count))
        return self[Int(randomNum)] as! NSObject
    }
    
}

extension UIImageView {
    func downloadedFrom( actInd: UIActivityIndicatorView, url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        actInd.startAnimating()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                actInd.stopAnimating()
            }
            }.resume()
    }
    func downloadedFrom(  actInd: UIActivityIndicatorView, link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom( actInd: actInd, url: url, contentMode: mode)
    }
}
