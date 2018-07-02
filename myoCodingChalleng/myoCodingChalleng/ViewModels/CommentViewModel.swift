//
//  CommentViewModel.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 02.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

protocol CommentViewModelDelegate: class {
    func didReceiveComments(comments: [Comment]?, nextPageToken: String)
    func didFailGetCommentsWithError(error: Error? )
}

class CommentViewModel {
    
    weak var delegate: CommentViewModelDelegate?
    
    internal var service = Service()
    
    func getComments(forVideo videoId: String, nextPageToken: String? = nil) {
        
        var urlString = ""
        
        if let token = nextPageToken {
            urlString = "\(URLs.baseURL)\(URLs.commentObject)pageToken=\(token)&videoId=\(videoId)\(URLs.commentType)&key=\(Keys.apiKey)"
        } else {
            urlString = "\(URLs.baseURL)\(URLs.commentObject)videoId=\(videoId)\(URLs.commentType)&key=\(Keys.apiKey)"
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
                    self.delegate?.didFailGetCommentsWithError(error: error)
                }
                
                guard let resultsDict = _resultsDict, let nextPageToken = resultsDict["nextPageToken"] as? String, let commentsJson = resultsDict["items"] as? [[String : Any]] else {
                    self.delegate?.didFailGetCommentsWithError(error: error)
                    return
                }
                
                var commentsArray = [Comment]()
                
                for commentJson in commentsJson {
                    if let comment = Comment.init(withJson: commentJson) {
                        commentsArray.append(comment)
                    }
                }
                
                self.delegate?.didReceiveComments(comments: commentsArray, nextPageToken: nextPageToken)
            } else {
                self.delegate?.didFailGetCommentsWithError(error: error)
            }
        }
    }
}
