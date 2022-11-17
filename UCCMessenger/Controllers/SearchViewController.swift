//
//  SearchViewController.swift
//  UCCMessenger
//
//  Created by Cian Keeney on 11/14/22.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController()
    
    private var users = ["Person 1", "Person 2", "Person 3", "Person 4", "Person 5", "Person 6", "Person 7", "Person 8", "Person 9", "Person 10", "Person 11", "Person 12", "Person 13", "Person 14", "Person 15", "Person 16", "Person 17", "Person 18", "Person 19", "Person 20"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    
    @objc(updateSearchResultsForSearchController:) func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
            
        }
        print(text)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}


