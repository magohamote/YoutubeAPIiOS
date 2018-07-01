//
//  ViewController.swift
//  myoCodingChalleng
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var nextPageToken: String?
    var searchTerms: String?
    
    let dataSource = SearchViewModel()
    internal var videosArray = [Video]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextPageToken = ""
        searchTerms = ""
        
        searchBar.delegate = self
        dataSource.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchTerms = text
            dataSource.search(withSearchTerms: text)
        }
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchTerms = text
            dataSource.search(withSearchTerms: text)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == videosArray.count - 5 {
            if let searchTerms = self.searchTerms {
                dataSource.search(withSearchTerms: searchTerms, nextPageToken: nextPageToken)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
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

extension ViewController: SearchViewModelDelegate {
    func didReceiveSearchResult(videos: [Video]?, nextPageToken: String) {
        if let videos = videos {
            self.videosArray.append(contentsOf: videos)
        }
        self.nextPageToken = nextPageToken
    }
    
    func didFailGetSearchResultWithError(error: Error?) {
        print(error)
    }
}
