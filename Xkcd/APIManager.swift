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
    
    func getData() {
        Alamofire.request("http://xkcd.com/json.html").validate().responseJSON { response in
            
            if let data = response.result.value {
                let json = JSON(data)
       
            }
        }
    }
    
}
