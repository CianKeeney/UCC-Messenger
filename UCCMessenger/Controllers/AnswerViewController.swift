//
//  AnswerViewController.swift
//  UCCMessenger
//
//  Created by Cian Keeney on 07/02/2023.
//

import Foundation
import UIKit

class AnswerViewController: UIViewController, UITableViewDataSource {

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()

    var users: [String] = Array(0...100).compactMap({ "user \($0)" })

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.backgroundColor = .blue
    }

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
