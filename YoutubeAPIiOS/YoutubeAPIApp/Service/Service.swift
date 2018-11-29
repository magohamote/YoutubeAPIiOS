//
//  Service.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

enum httpMethod: String {
    case GET = "GET"
}

class Service {
    
    func performGetRequest(targetURL: URL, completion: @escaping (_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void) {
        var request = URLRequest(url: targetURL)
        request.httpMethod = httpMethod.GET.rawValue
        
        let sessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfiguration)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }
        
        task.resume()
    }
}
