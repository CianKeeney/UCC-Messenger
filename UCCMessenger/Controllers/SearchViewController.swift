//
//  ViewController.swift
//  SearchController
//
//  Created by Afraz Siddiqui on 3/16/21.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: ViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        view.backgroundColor = .systemBackground
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        let vc = searchController.searchResultsController as? ViewController
        guard !text.isEmpty else {
            vc?.tableView.isHidden = true
            return
        }
        vc?.tableView.isHidden = false
        print(text)
    }
}
