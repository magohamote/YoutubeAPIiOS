//
//  YoutubeAPIAppUITest.swift
//  YoutubeAPIAppUITest
//
//  Created by Cédric Rolland on 03.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import XCTest

class YoutubeAPIAppUITest: XCTestCase {
    
    var app:XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        app = XCUIApplication()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testSearch() {
        search(terms: "vaporwave")
    }
    
    func testInfiniteScroll() {
        search(terms: "vaporwave")
        app.tables["videoTableView"].swipeUp()
        app.tables["videoTableView"].swipeUp()
        app.tables["videoTableView"].swipeUp()
    }
    
    func testDisplayComments() {
        search(terms: "xxx")
        app.tables["videoTableView"]/*@START_MENU_TOKEN@*/.staticTexts["XXXTENTACION - SAD! (Official Music Video)"]/*[[".cells.staticTexts[\"XXXTENTACION - SAD! (Official Music Video)\"]",".staticTexts[\"XXXTENTACION - SAD! (Official Music Video)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.webViews/*@START_MENU_TOKEN@*/.buttons["Play"]/*[[".otherElements[\"YouTube video player\"]",".otherElements[\"YouTube Video Player\"].buttons[\"Play\"]",".buttons[\"Play\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    func search(terms: String) {
        let searchField = app/*@START_MENU_TOKEN@*/.searchFields["Search in YouTube"]/*[[".otherElements[\"searchBar\"].searchFields[\"Search in YouTube\"]",".searchFields[\"Search in YouTube\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertNotNil(searchField)
        searchField.tap()
        searchField.typeText(terms)
        app.buttons["Search"].tap()
    }
}
