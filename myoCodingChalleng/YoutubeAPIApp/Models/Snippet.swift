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
    var thumbnail: Thumbnail?
    var channelTitle: String
    
    init(title: String, publishedAt: String, description: String, thumbnail: Thumbnail, channelTitle: String) {
        self.title = title
        self.publishedAt = publishedAt
        self.description = description
        self.thumbnail = thumbnail
        self.channelTitle = channelTitle
    }
    
    init?(withJson json: [String : Any]?) {
        if let title = json?["title"] as? String,
            let publishedAt = json?["publishedAt"] as? String,
            let description = json?["description"] as? String,
            let thumbnailsJson = json?["thumbnails"] as? [String : Any],
            let channelTitle = json?["channelTitle"] as? String {
            
            self.title = title
            self.publishedAt = publishedAt
            self.description = description
            self.channelTitle = channelTitle

            if let thumbnailData = thumbnailsJson["default"] as? [String : Any], let thumbnailDefault = Thumbnail.init(withJson: thumbnailData) {
                self.thumbnail = thumbnailDefault
            }
            
        } else {
            return nil
        }
    }
}
