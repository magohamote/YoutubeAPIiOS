//
//  Snippet.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

struct Snippet {
    var title: String
    var publishedAt: String
    var description: String
    var thumbnails: [Thumbnail]
    
    init(title: String, publishedAt: String, description: String, thumbnails: [Thumbnail]) {
        self.title = title
        self.publishedAt = publishedAt
        self.description = description
        self.thumbnails = thumbnails
    }
    
    init?(withJson json: [String : Any]?) {
        if let title = json?["title"] as? String,
            let publishedAt = json?["publishedAt"] as? String,
            let description = json?["description"] as? String,
            let thumbnailsJson = json?["thumbnails"] as? [String : Any] {
            
            self.title = title
            self.publishedAt = publishedAt
            self.description = description
            self.thumbnails = [Thumbnail]()

            if let thumbnailData = thumbnailsJson["default"] as? [String : Any], let thumbnailDefault = Thumbnail.init(withJson: thumbnailData) {
                self.thumbnails.append(thumbnailDefault)
            }
            
        } else {
            return nil
        }
    }
}
