//
//  Comment.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 02.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

struct Comment {
    var authorDisplayName: String
    var authorProfileImageUrl: URL
    var textDisplay: String
    var likeCount: Int
    
    init(authorDisplayName: String, authorProfileImageUrl: URL, textDisplay: String, likeCount: Int) {
        self.authorDisplayName = authorDisplayName
        self.authorProfileImageUrl = authorProfileImageUrl
        self.textDisplay = textDisplay
        self.likeCount = likeCount
    }
    
    init?(withJson json:[String : Any]?) {
        if let snippet = json?["snippet"] as? [String : Any],
            let topLevelComment = snippet["topLevelComment"] as? [String : Any],
            let commentSnippet = topLevelComment["snippet"] as? [String : Any],
            let authorDisplayName = commentSnippet["authorDisplayName"] as? String,
            let authorProfileImageUrlString = commentSnippet["authorProfileImageUrl"] as? String,
            let authorProfileImageUrl = URL(string: authorProfileImageUrlString),
            let textDisplay = commentSnippet["textDisplay"] as? String,
            let likeCount = commentSnippet["likeCount"] as? Int {
            
            self.authorDisplayName = authorDisplayName
            self.authorProfileImageUrl = authorProfileImageUrl
            self.textDisplay = textDisplay
            self.likeCount = likeCount
        } else {
            return nil
        }
    }
}
