//
//  TestViewModels.swift
//  YoutubeAPIAppUnitTest
//
//  Created by Cédric Rolland on 03.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import XCTest
import Foundation
@testable import YoutubeAPIApp

class TestViewModels: XCTestCase, SearchViewModelDelegate, CommentViewModelDelegate {
    
    var searchViewModel: SearchViewModel!
    var commentViewModel: CommentViewModel!
    
    override func setUp() {
        super.setUp()
        
        searchViewModel = SearchViewModel()
        commentViewModel = CommentViewModel()
        
        searchViewModel.service = MockService()
        commentViewModel.service = MockService()
        
        searchViewModel.delegate = self
        commentViewModel.delegate = self
    }
    
    override func tearDown() {
        searchViewModel = nil
        commentViewModel = nil
        super.tearDown()
    }
    
    // MARK: - Search View Model
    
    func testSearchViewModel() {
        searchViewModel.search(withSearchTerms: "video_list")
    }
    
    func didReceiveSearchResult(videos: [Video]?, nextPageToken: String) {
        XCTAssertNotNil(videos)
        XCTAssertEqual(videos!.count, 5)
        XCTAssertEqual(videos![0].id, "UJsUpeXK6Jo")
    }
   
    func didFailGetSearchResultWithError(error: Error?) {
        XCTAssertNil(error)
    }
    
    // MARK: - Comment View Model
    
    func testCommentsViewModel() {
        commentViewModel.getComments(forVideo: "comment_list")
    }
    
    func didReceiveComments(comments: [Comment]?, nextPageToken: String) {
        XCTAssertNotNil(comments)
        XCTAssertEqual(comments![0].authorDisplayName, "mresstell")
        XCTAssertEqual(comments![0].authorProfileImageUrl, URL(string: "https://yt3.ggpht.com/-CTGx4buFcKc/AAAAAAAAAAI/AAAAAAAAAAA/EkwYKVLT4k8/s28-c-k-no-mo-rj-c0xffffff/photo.jpg")!)
        XCTAssertEqual(comments![0].likeCount, 0)
        XCTAssertEqual(comments![0].textDisplay, "Wonderful!")
    }
    
    func didFailGetCommentsWithError(error: Error?) {
        XCTAssertNil(error)
    }
}
