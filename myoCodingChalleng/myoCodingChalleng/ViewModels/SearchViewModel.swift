//
//  SearchViewModel.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

protocol SearchViewModelDelegate: class {
    func didReceiveSearchResult(videos: [Video]?, nextPageToken: String)
    func didFailGetSearchResultWithError(error: Error? )
}

class SearchViewModel {
    
    weak var delegate: SearchViewModelDelegate?
    
    internal var service = Service()
    
    func search(withSearchTerms searchTerms: String, nextPageToken: String? = nil) {
        
        var urlString = ""
        
        if let token = nextPageToken, token.count > 0 {
            urlString = "\(URLs.baseURL)\(URLs.searchedObject)pageToken=\(token)&q=\(searchTerms)\(URLs.searchType)&key=\(Keys.apiKey)"
        } else {
            urlString = "\(URLs.baseURL)\(URLs.searchedObject)q=\(searchTerms)\(URLs.searchType)&key=\(Keys.apiKey)"
        }
        
        guard let targetURL = URL(string: urlString) else {
            return
        }
        
        service.performGetRequest(targetURL: targetURL) { (data, urlResponse, error) in
            if let _ = urlResponse, let data = data, error == nil {
                var _resultsDict: [String : Any]?
                
                do {
                    _resultsDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
                } catch {
                    self.delegate?.didFailGetSearchResultWithError(error: error)
                }
                
                guard let resultsDict = _resultsDict, let videosJson = resultsDict["items"] as? [[String : Any]] else {
                    self.delegate?.didFailGetSearchResultWithError(error: error)
                    return
                }
                
                var nextPageToken = ""
                if let nextPageTokenString = resultsDict["nextPageToken"] as? String {
                    nextPageToken = nextPageTokenString
                }
                
                var videosArray = [Video]()
                
                for videoJson in videosJson {
                    if let video = Video.init(withJson: videoJson) {
                        videosArray.append(video)
                    }
                }
                
                self.delegate?.didReceiveSearchResult(videos: videosArray, nextPageToken: nextPageToken)
            } else {
                self.delegate?.didFailGetSearchResultWithError(error: error)
            }
        }
    }
}
