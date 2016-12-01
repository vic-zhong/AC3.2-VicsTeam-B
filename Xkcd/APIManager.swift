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
    
    func getData(url: URL, completionHandler: @escaping (Comic?) -> Void) {
        Alamofire.request(url).validate().responseJSON { response in
            let json = JSON(response.result.value)
            let image = json["img"].string
            
            let validComic = Comic(image: image!)
            completionHandler(validComic)
        }
    }
    
}
