//
//  APIManager.swift
//  Xkcd
//
//  Created by Eric Chang on 12/1/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {
    
    func getData(completionHandler: @escaping () -> Void) {
        for i in 1..<50 {
            Alamofire.request("http://xkcd.com/\(i)/info.0.json").validate().responseJSON { response in
                
                if let data = response.result.value {
                    let json = JSON(data)
                    if let image = json["img"].string {
                        let validComic = Comic(image: image)
                        comic.append(validComic)
                        completionHandler(self.loadImage())
                    }
                }
            }
        }
    }
    
    func loadImage() {
        for each in comic {
            let this = URL(string: each.image)!
            let shareSession = URLSession.shared
            let downloadTask = shareSession.downloadTask(with: this, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
                if location != nil {
                    DispatchQueue.main.async {
                        let data:Data! = try? Data(contentsOf: this)
                        let image = UIImage(data: data)
                        ourImage.append(image!)
                    }
                }
            })
            downloadTask.resume()
        }
    }
}
