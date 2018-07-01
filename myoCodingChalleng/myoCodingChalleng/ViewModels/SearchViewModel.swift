//
//  SearchViewModel.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

protocol SearchViewModelDelegate: class {
    func didReceiveSearchResult(videos: [Video]?)
    func didFailGetSearchResultWithError(error: Error? )
}

class SearchViewModel {
    
    weak var delegate: SearchViewModelDelegate?
    
    internal var service = Service()
    
    func search(searchTerms: String) {
        let urlString = "\(URLs.baseURL)\(URLs.searchedObject)&q=\(searchTerms)\(URLs.searchType)&key=\(Keys.apiKey)"
        
        print(urlString)
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
                
                var videos = [Video]()
                
                for videoJson in videosJson {
                    if let video = Video.init(withJson: videoJson) {
                        videos.append(video)
                    }
                }
                
                self.delegate?.didReceiveSearchResult(videos: videos)
            } else {
                self.delegate?.didFailGetSearchResultWithError(error: error)
            }
        }
    }
}
