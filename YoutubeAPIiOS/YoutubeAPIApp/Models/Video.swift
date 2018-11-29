//
//  Video.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

struct Video {
    
    var id: String
    var snippet: Snippet
    
    init(id: String, snippet: Snippet) {
        self.id = id
        self.snippet = snippet
    }
    
    init?(withJson json: [String : Any]?) {
        if let idJson = json?["id"] as? [String : Any], let id = idJson["videoId"] as? String,
            let snippetJson = json?["snippet"] as? [String : Any],
            let snippet = Snippet.init(withJson: snippetJson) {
            
            self.snippet = snippet
            self.id = id
        } else {
            return nil
        }
    }
}

