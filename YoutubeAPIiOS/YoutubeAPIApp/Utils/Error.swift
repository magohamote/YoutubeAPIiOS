//
//  Error.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 03.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

enum FormatError: Error {
    case badFormatError
}

enum QueryError: Error {
    case noResponseError
}
