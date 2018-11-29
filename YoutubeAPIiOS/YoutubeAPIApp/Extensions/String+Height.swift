//
//  String+Height.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 02.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import Foundation

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
