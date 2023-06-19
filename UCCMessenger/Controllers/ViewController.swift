//
//  ViewController.swift
//  UCCMessenger
//
//  Created by Cian Keeney on 22/03/2023.
//

import Foundation
import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
     var models = ["Cian Keeney", "Dan Griffin", "Eoghan Daly, Cian Keeney", "Hamza Khan", "Emma Smith", "Karim Smith", "John Smith", "Emma Smith, Cian Keeney", "Timothy McGrath", "Daniel Kiely", "Emma Stubbs", "Kitty Smith", "Kate Geronimo", "Grant Geronimo", "Alex Eubank", "Lexx Little", "Soosh Brah", "Manic Mike"]

//    var models: [String] = Array(0...100).compactMap({ "\($0) item" })

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        return cell
    }
}

