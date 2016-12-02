//
//  Comic.swift
//  Xkcd
//
//  Created by Eric Chang on 12/1/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import Foundation

class Comic{
    let image: String
    let id: Int
    
    init(image: String, id: Int) {
        self.image = image
        self.id = id
    }
}
