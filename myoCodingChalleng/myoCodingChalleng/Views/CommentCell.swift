//
//  CommentCell.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 02.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import UIKit
import SDWebImage

class CommentCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var likeCountsLabel: UILabel!
    
    func config(withComment comment: Comment) {
        userImageView.sd_setImage(with: comment.authorProfileImageUrl, placeholderImage: nil, completed: nil)
        authorNameLabel.text = comment.authorDisplayName
        commentLabel.text = comment.textDisplay
        likeCountsLabel.text = "\(comment.likeCount)"
    }
}

