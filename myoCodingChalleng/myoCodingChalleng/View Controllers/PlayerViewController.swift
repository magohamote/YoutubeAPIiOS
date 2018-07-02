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
        
        tableView.separatorColor = .clear
        
        if let videoId = self.videoId {
            showLoadingView(onView: playerView)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let margin:CGFloat = 15
        let avatarSize:CGFloat = 67.5
        let commentWidth: CGFloat = view.frame.width - 3 * margin - avatarSize
        let commentHeight = commentsArray[indexPath.row].textDisplay.height(withConstrainedWidth: commentWidth, font: UIFont.systemFont(ofSize: 17))
        
        let totalHeight = commentHeight + 2 * margin + 10 + 21
        
        if totalHeight < 98 {
            return 98
        } else {
            return totalHeight
        }
    }
}

extension PlayerViewController: CommentViewModelDelegate {
    func didReceiveComments(comments: [Comment]?, nextPageToken: String) {
        if let comments = comments {
            self.commentsArray.append(contentsOf: comments)
        }
        self.nextPageToken = nextPageToken
        tableView.separatorColor = .lightGray
    }
    
    func didFailGetCommentsWithError(error: Error?) {
        tableView.alpha = 0
    }
}
