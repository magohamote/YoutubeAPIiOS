//
//  VideoCell.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import UIKit
import SDWebImage

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var channelLabel: UILabel?
    
    func config(withVideo video: Video?) {
        if let thumbnail = video?.snippet.thumbnail {
            thumbnailImageView?.sd_setImage(with: thumbnail.url, placeholderImage: UIImage(named: "videoPlaceholder"), completed: nil)
        } else {
            
            thumbnailImageView?.image = UIImage(named: "videoPlaceholder")
        }
        titleLabel?.text = video?.snippet.title
        channelLabel?.text = video?.snippet.channelTitle
    }
}
