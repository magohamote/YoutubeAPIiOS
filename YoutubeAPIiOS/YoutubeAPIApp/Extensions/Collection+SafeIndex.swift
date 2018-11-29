//
//  Collection+SafeIndex.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 29.11.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
