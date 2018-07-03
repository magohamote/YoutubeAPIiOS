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
        
        var urlString = "\(URLs.baseURL)\(URLs.searchedObject)q=\(searchTerms)\(URLs.searchType)&key=\(Keys.apiKey)"
        
        if let token = nextPageToken, token.count > 0 {
            urlString = "\(urlString)&pageToken=\(token)"
        }
        
        if let targetURL = URL(string: urlString) {
            service.performGetRequest(targetURL: targetURL, completion: setVideo)
        }
    }
    
    private func setVideo(withData data: Data?, urlResponse: URLResponse?, error: Error?) {
        if let _ = urlResponse, let data = data {
            var _resultsDict: [String : Any]?
            
            do {
                _resultsDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
            } catch {
                self.delegate?.didFailGetSearchResultWithError(error: FormatError.badFormatError)
            }
            
            guard let resultsDict = _resultsDict, let videosJson = resultsDict["items"] as? [[String : Any]] else {
                self.delegate?.didFailGetSearchResultWithError(error: FormatError.badFormatError)
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
        } else if let error = error {
            self.delegate?.didFailGetSearchResultWithError(error: error)
        } else {
            self.delegate?.didFailGetSearchResultWithError(error: QueryError.noResponseError)
        }
    }
}
