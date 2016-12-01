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
    
    func getData(completionHandler: @escaping (Comic?) -> Void) {
        for i in 1..<50 {
            Alamofire.request("http://xkcd.com/\(i)/info.0.json").validate().responseJSON { response in
                
                if let data = response.result.value {
                    let json = JSON(data)
                    if let image = json["img"].string {
                        let validComic = Comic(image: image)
                        comic.append(validComic)
                    }
                }
            }
        }
    }
    
}
