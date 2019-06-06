//
//  SearchViewController.swift
//  YoutubeAPIApp
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var tableView: UITableView?
    
    private let dataSource = SearchViewModel()
    
    private var loadingView: UIView?
    private var nextPageToken: String?
    private var searchTerms: String?
    private var tap: UITapGestureRecognizer?
    private var videosArray = [Video]() {
        didSet {
            
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Youtube API app"
            
        nextPageToken = ""
        searchTerms = ""
        
        
        searchBar?.delegate = self
        dataSource.delegate = self
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard(_:)))
        if let tap = self.tap {
            view.addGestureRecognizer(tap)
        }
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar?.endEditing(true)
        tap?.isEnabled = false
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tap?.isEnabled = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchTerms = text
            
            videosArray.removeAll()
            
            loadingView = createLoadingView()
            guard let loadingView = loadingView else {
                return
            }
            view.addSubview(loadingView)
            
            dataSource.search(withSearchTerms: text.trimmingCharacters(in: .whitespacesAndNewlines))
            
            searchBar.endEditing(true)
            
            tap?.isEnabled = false
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == videosArray.count - 5 {
            if let searchTerms = self.searchTerms {
                dataSource.search(withSearchTerms: searchTerms, nextPageToken: nextPageToken)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: PlayerViewController.identifier) as? PlayerViewController else {
            return
        }
        vc.videoId = videosArray[safe: indexPath.row]?.id
        vc.title = videosArray[safe: indexPath.row]?.snippet.title
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.identifier) as? VideoCell else {
            return UITableViewCell()
        }
        cell.config(withVideo: videosArray[safe: indexPath.row])
        return cell
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func didReceiveSearchResult(videos: [Video]?, nextPageToken: String) {
        hideLoadingView()
        if let videos = videos {
            if videos.count == 0 {
                showMessage(withTitle: "No video", withMessage: "Sorry, we didn't find any video.")
            } else {
                videosArray.append(contentsOf: videos)
            }
        }
        self.nextPageToken = nextPageToken
    }
    
    func didFailGetSearchResultWithError(error: Error?) {
        hideLoadingView()
        if let error = error {
            showMessage(withTitle: "Error", withMessage: error.localizedDescription)
        } else {
            showMessage(withTitle: "Error", withMessage: "An unknown error occured")
        }
    }
    
    private func hideLoadingView() {
        loadingView?.removeFromSuperview()
        tableView?.refreshControl?.endRefreshing()
    }
}
