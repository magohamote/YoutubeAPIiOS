//
//  Thumbnail.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

struct Thumbnail {
    var url: URL
    var width: Int
    var height: Int
    
    init(url: URL, width: Int, height: Int) {
        self.url = url
        self.width = width
        self.height = height
    }
    
    init?(withJson json: [String : Any]?) {
        if let urlString = json?["url"] as? String,
            let url = URL(string: urlString),
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
