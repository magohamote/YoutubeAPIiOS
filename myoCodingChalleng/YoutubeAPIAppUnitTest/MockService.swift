//
//  MockService.swift
//  YoutubeAPIAppUnitTest
//
//  Created by Cédric Rolland on 03.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation
@testable import YoutubeAPIApp

class MockService: Service {
    
    typealias UniqueResult = [String: Any]
    
    private var htmlResponse = HTTPURLResponse(url: NSURL(string: "dummyURL")! as URL, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
    
    override func performGetRequest(targetURL: URL, completion: @escaping (_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Void) {
        
        var name = ""
        
        if targetURL.absoluteString.contains("video_list") {
            name = "video_list"
        } else if targetURL.absoluteString.contains("comment_list") {
            name = "comment_list"
        } else if targetURL.absoluteString.contains("bad_json") {
            name = "bad_json"
        } else {
            name = ""
        }
        
        let data = getTestData(name: name)
        MockRequest.response.data = htmlResponse
        
        do {
            MockRequest.response.json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
        } catch {
            completion(nil, nil, nil)
            return
        }
        
        _ = request("dummyURL").responseJSON { (request, response, JSON, error) -> Void in
            if let jsonData = JSON {
                do {
                    let data = try JSONSerialization.data(withJSONObject: jsonData, options: JSONSerialization.WritingOptions.prettyPrinted) as Data
                    completion(data, response, nil)
                } catch {
                    completion(nil, response, FormatError.badFormatError)
                }
                
            } else {
                completion(nil, nil, error)
            }
        }
    }
    
    private func request(_ url: String) -> MockRequest {
        return MockRequest(request: url)
    }
    
    private func getTestData(name: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: name, ofType: "json")
        return try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
    }
}
