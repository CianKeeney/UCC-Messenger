//
//  SearchViewController.swift
//  UCCMessenger
//
//  Created by Cian Keeney on 11/14/22.
//

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource {

//    let searchController = UISearchController(searchResultsController: self())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.backgroundColor = .blue
//        searchController.searchResultsUpdater = self
//        navigationItem.searchController = searchController
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        let vc = searchController.searchResultsController as? Self
        guard !text.isEmpty else {
            vc?.tableView.isHidden = true
            return
        }
        vc?.tableView.isHidden = false
        print(text)
    }
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()

    var users: [String] = Array(0...100).compactMap({ "user \($0)" })

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = users[indexPath.row]
        return cell
    }
}



