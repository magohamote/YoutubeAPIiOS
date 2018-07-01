//
//  PlayerViewController.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    var videoId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let videoId = self.videoId {
            playerView.load(withVideoId: videoId)
        }
    }
}
