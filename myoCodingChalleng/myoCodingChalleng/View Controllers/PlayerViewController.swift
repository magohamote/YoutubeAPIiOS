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
    @IBOutlet weak var tableView: UITableView!
    
    var videoId: String?
    
    private var nextPageToken: String?
    private let dataSource = CommentViewModel()
    
    internal var commentsArray = [Comment]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        if let videoId = self.videoId {
            playerView.load(withVideoId: videoId)
            dataSource.getComments(forVideo: videoId)
        }
    }
}

extension PlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier) as? CommentCell {
            cell.config(withComment: commentsArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension PlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == commentsArray.count - 5 {
            if let videoId = self.videoId {
                dataSource.getComments(forVideo: videoId, nextPageToken: nextPageToken)
            }
        }
    }
}

extension PlayerViewController: CommentViewModelDelegate {
    func didReceiveComments(comments: [Comment]?, nextPageToken: String) {
        if let comments = comments {
            self.commentsArray.append(contentsOf: comments)
        }
        self.nextPageToken = nextPageToken
    }
    
    func didFailGetCommentsWithError(error: Error?) {
        print(error)
    }
}
