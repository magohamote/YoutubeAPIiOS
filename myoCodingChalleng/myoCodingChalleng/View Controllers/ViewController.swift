//
//  ViewController.swift
//  myoCodingChalleng
//
//  Created by Cédric Rolland on 01.07.18.
//  Copyright © 2018 Cédric Rolland. All rights reserved.
//

import UIKit
import ModernSearchBar

class ViewController: UIViewController, ModernSearchBarDelegate {

    @IBOutlet weak var searchBar: ModernSearchBar!
    
    let searchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegateModernSearchBar = self
        searchViewModel.delegate = self
        
        searchViewModel.search(searchTerms: "vaporwave")
    }
}

extension ViewController: SearchViewModelDelegate {
    func didReceiveSearchResult(videos: [Video]?) {
        print(videos)
    }
    
    func didFailGetSearchResultWithError(error: Error?) {
        print(error)
    }
}
