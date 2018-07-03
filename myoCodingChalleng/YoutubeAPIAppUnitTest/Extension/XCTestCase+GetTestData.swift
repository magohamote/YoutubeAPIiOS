//
//  XCTestCase+GetTestData.swift
//  YoutubeAPIAppUnitTest
//
//  Created by Cédric Rolland on 03.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func getTestData(name: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: name, ofType: "json")
        return try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
    }
}
