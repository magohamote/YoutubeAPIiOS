//
//  Constants.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

struct Keys {
    static let apiKey = "AIzaSyDJca1udtM3HkRlFY6F0Qp0O1JxQA5ePco"
}

struct URLs {
    static let baseURL = "https://www.googleapis.com/youtube/v3/"
    static let searchedObject = "search?"
    static let commentObject = "commentThreads?"
    static let searchType =  "&type=video&part=snippet"
    static let commentType = "&textFormat=plainText&part=snippet&maxResults=50"
}


