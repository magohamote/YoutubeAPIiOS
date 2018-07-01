//
//  Thumbnail.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

struct Thumbnail {
    var url: String
    var width: Int
    var height: Int
    
    init(url: String, width: Int, height: Int) {
        self.url = url
        self.width = width
        self.height = height
    }
    
    init?(withJson json: [String : Any]?) {
        if let url = json?["url"] as? String,
            let width = json?["width"] as? Int,
            let height = json?["height"] as? Int {
            
            self.url = url
            self.width = width
            self.height = height
        } else {
            return nil
        }
    }
}
