//
//  TestModels.swift
//  YoutubeAPIAppUnitTest
//
//  Created by Cédric Rolland on 03.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import XCTest
import Foundation

@testable import YoutubeAPIApp

class TestModels: XCTestCase {
    
    // MARK: - Video Model
    
    func testSuccesfulVideoJsonInit() {
        let data = getTestData(name: "video_list")
        
        do {
            let _jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            if let jsonData = _jsonData, let videoJson = jsonData["items"] as? [String : Any] {
                XCTAssertNotNil(Video(withJson: videoJson))
            }
        } catch {
            XCTFail()
        }
    }
    
    func testSuccessfulVideoInit() {
        XCTAssertNotNil(Video.init(id: "id", snippet:
            Snippet.init(title:"title", publishedAt:"publishedAt", description:"description", thumbnail:
                Thumbnail.init(url: URL(string: "https://i.ytimg.com/vi/fxn8p26WTR4/mqdefault_live.jpg")!, width:2, height:2), channelTitle:"channelTitle")))
    }
    
    func testFailingVideoJsonInit() {
        let data = getTestData(name: "bad_list")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNil(Video(withJson: jsonData))
        } catch {
            XCTFail()
        }
    }
    
    // MARK: - Comment Model
    
    func testSuccesfulCommentJsonInit() {
        let data = getTestData(name: "comment_list")
        
        do {
            let _jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            if let jsonData = _jsonData, let commentJson = jsonData["items"] as? [String : Any] {
                XCTAssertNotNil(Comment(withJson: commentJson))
            }
        } catch {
            XCTFail()
        }
    }
    
    func testSuccessfulCommentInit() {
        XCTAssertNotNil(Comment.init(authorDisplayName: "authorDisplayName", authorProfileImageUrl: URL(string: "https://i.ytimg.com/vi/fxn8p26WTR4/mqdefault_live.jpg")!, textDisplay: "textDisplay", likeCount: 0))
    }
    
    func testFailingCommentJsonInit() {
        let data = getTestData(name: "bad_list")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNil(Comment(withJson: jsonData))
        } catch {
            XCTFail()
        }
    }
    
    // MARK: Snippet Model
    
    func testSuccesfulSnippetJsonInit() {
        let data = getTestData(name: "snippet")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNotNil(Snippet(withJson: jsonData))
        } catch {
            XCTFail()
        }
    }
    
    func testSuccessfulSnippetInit() {
        XCTAssertNotNil(Snippet.init(title: "title", publishedAt: "publishedAt", description: "description", thumbnail: Thumbnail.init(url: URL(string: "https://i.ytimg.com/vi/fxn8p26WTR4/mqdefault_live.jpg")!, width:0, height:0), channelTitle: "channelTitle"))
    }
    
    func testFailingSnippetJsonInit() {
        let data = getTestData(name: "bad_snippet")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNil(Comment(withJson: jsonData))
        } catch {
            XCTFail()
        }
    }
    
    // MARK: Thumbnail Model
    
    func testSuccesfulThumbnailJsonInit() {
        let data = getTestData(name: "thumbnail")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNotNil(Thumbnail(withJson: jsonData))
        } catch {
            XCTFail()
        }
    }
    
    func testSuccessfulThumbnailInit() {
        XCTAssertNotNil(Thumbnail.init(url: URL(string: "https://i.ytimg.com/vi/fxn8p26WTR4/mqdefault_live.jpg")!, width:0, height:0))
    }
    
    func testFailingThumbnailJsonInit() {
        let data = getTestData(name: "bad_thumbnail")
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            XCTAssertNil(Comment(withJson: jsonData))
        } catch {
            XCTFail()
        }
    }
}

