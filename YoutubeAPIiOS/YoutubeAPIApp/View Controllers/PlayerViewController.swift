//
//  PlayerViewController.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView?
    @IBOutlet weak var tableView: UITableView?
    
    var videoId: String?
    
    private var nextPageToken: String?
    private let dataSource = CommentViewModel()
    
    private var commentsArray = [Comment]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.tableFooterView = UIView()
        
        if let videoId = self.videoId {
            playerView?.load(withVideoId: videoId)
            dataSource.getComments(forVideo: videoId)
        }
    }
}

extension PlayerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier) as? CommentCell else {
            return UITableViewCell()
        }
        cell.config(withComment: commentsArray[safe: indexPath.row])
        return cell
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
            commentsArray.append(contentsOf: comments)
        }
        self.nextPageToken = nextPageToken
    }
    
    func didFailGetCommentsWithError(error: Error?) {
        showMessage(withTitle: "Error", withMessage: error?.localizedDescription ?? "An unexpected error occurred")
    }
}
