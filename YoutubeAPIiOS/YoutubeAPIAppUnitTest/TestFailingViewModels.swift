//
//  TestFailingViewModels.swift
//  YoutubeAPIAppUnitTest
//
//  Created by Cédric Rolland on 03.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import XCTest
import Foundation
@testable import YoutubeAPIApp

class TestFailingViewModels: XCTestCase, SearchViewModelDelegate, CommentViewModelDelegate {
    
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
    
    func testFailingSearchViewModel() {
        searchViewModel.search(withSearchTerms: "bad_json")
    }
    
    func didReceiveSearchResult(videos: [Video]?, nextPageToken: String) {
        XCTAssertNil(videos)
    }
    
    func didFailGetSearchResultWithError(error: Error?) {
        XCTAssertNotNil(error)
        XCTAssertEqual(error!.localizedDescription, QueryError.noResponseError.localizedDescription)
    }
    
    
    // MARK: - Comment View Model
    
    func testCommentsViewModel() {
        commentViewModel.getComments(forVideo: "bad_json")
    }
    
    func didReceiveComments(comments: [Comment]?, nextPageToken: String) {
        XCTAssertNil(comments)
    }
    
    func didFailGetCommentsWithError(error: Error?) {
        XCTAssertNotNil(error)
        XCTAssertEqual(error!.localizedDescription, QueryError.noResponseError.localizedDescription)
    }
}

