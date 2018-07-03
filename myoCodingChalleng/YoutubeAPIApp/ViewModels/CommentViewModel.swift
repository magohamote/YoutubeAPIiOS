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
        var urlString = "\(URLs.baseURL)\(URLs.commentObject)videoId=\(videoId)\(URLs.commentType)&key=\(Keys.apiKey)"
        
        if let token = nextPageToken, token.count > 0 {
            urlString = "\(urlString)&pageToken=\(token)"
        }
        
        if let targetURL = URL(string: urlString) {
            service.performGetRequest(targetURL: targetURL, completion: setComments)
        } else {
            self.delegate?.didFailGetCommentsWithError(error: QueryError.noResponseError)
        }
    }
    
    private func setComments(withData data: Data?, urlResponse: URLResponse?, error: Error?) {
        if let _ = urlResponse, let data = data {
            var _resultsDict: [String : Any]?
            
            do {
                _resultsDict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : Any]
            } catch {
                self.delegate?.didFailGetCommentsWithError(error: FormatError.badFormatError)
            }
            
            guard let resultsDict = _resultsDict, let commentsJson = resultsDict["items"] as? [[String : Any]] else {
                self.delegate?.didFailGetCommentsWithError(error: FormatError.badFormatError)
                return
            }
            
            var nextPageToken = ""
            if let nextPageTokenString = resultsDict["nextPageToken"] as? String {
                nextPageToken = nextPageTokenString
            }
            
            var commentsArray = [Comment]()
            
            for commentJson in commentsJson {
                if let comment = Comment.init(withJson: commentJson) {
                    commentsArray.append(comment)
                }
            }
            
            self.delegate?.didReceiveComments(comments: commentsArray, nextPageToken: nextPageToken)
        } else if let error = error {
            self.delegate?.didFailGetCommentsWithError(error: error)
        } else {
            self.delegate?.didFailGetCommentsWithError(error: QueryError.noResponseError)
        }
    }
}
