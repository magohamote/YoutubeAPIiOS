//
//  SearchViewController.swift
//  myoCodingChalleng
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let dataSource = SearchViewModel()
    
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
        
        searchBar.delegate = self
        dataSource.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard(_:)))
        if let tap = self.tap {
            view.addGestureRecognizer(tap)
        }
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        searchBar.endEditing(true)
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
            
            dataSource.search(withSearchTerms: text.trimmingCharacters(in: .whitespacesAndNewlines))
            
            showLoadingView(onView: view)
            
            self.searchBar.endEditing(true)
            
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
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: PlayerViewController.identifier) as? PlayerViewController {
            vc.videoId = videosArray[indexPath.row].id
            vc.title = videosArray[indexPath.row].snippet.title
            self.navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VideoCell.identifier) as? VideoCell {
            cell.config(withVideo: videosArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension SearchViewController: SearchViewModelDelegate {
    func didReceiveSearchResult(videos: [Video]?, nextPageToken: String) {
        hideLoadingView(tableView: tableView)
        if let videos = videos {
            if videos.count == 0 {
                showMessage(withTitle: "No video", withMessage: "Sorry, we didn't find any video.")
            } else {
                self.videosArray.append(contentsOf: videos)
            }
        }
        self.nextPageToken = nextPageToken
    }
    
    func didFailGetSearchResultWithError(error: Error?) {
        hideLoadingView(tableView: tableView)
        if let error = error {
            showMessage(withTitle: "Error", withMessage: error.localizedDescription)
        } else {
            showMessage(withTitle: "Error", withMessage: "An unknown error occured")
        }
    }
}

