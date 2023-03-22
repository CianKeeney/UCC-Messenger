//
//  ViewController.swift
//  UCCMessenger
//
//  Created by Cian Keeney on 10/1/22.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
    
    @IBAction func NewConvoBtn(_ sender: UIBarButtonItem) {
        let vc = ChatViewController(with: "emma@gmail.com")
        vc.title = "New Chat"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private var users = ["Cian Keeney", "Dan Griffin", "Eoghan Daly, Cian Keeney", "Hamza Khan", "Emma Crowley", "Karim Smith", "John Smith", "Emma Crowley, Cian Keeney", "Timothy McGrath", "Daniel Kiely", "Emma Stubbs", "Kitty Smith", "Kate Geronimo", "Grant Geronimo", "Alex Eubank", "Lexx Little", "Soosh Brah", "Manic Mike"]
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        
//        DatabaseManager.shared.test()
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
        setupTableView()
        fetchConversations()
        self.tableView.rowHeight = 100.0
//        self.tableView.separatorStyle = .none
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
       
    }
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchConversations() {
        tableView.isHidden = false
    }

    
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let images = [UIImage(named: "Image 1"), UIImage(named: "Image 2"), UIImage(named: "Image 3"), UIImage(named: "Image 4"), UIImage(named: "Image 5"), UIImage(named: "Image 6"), UIImage(named: "Image 7"), UIImage(named: "Image 8"), UIImage(named: "Image 9"), UIImage(named: "Image 10"), UIImage(named: "Image 11"), UIImage(named: "Image 12"), UIImage(named: "Image 13"), UIImage(named: "Image 15"), UIImage(named: "Image 16"), UIImage(named: "Image 17"), UIImage(named: "Image 18"), UIImage(named: "Image 19")]
        
//        let image = UIImage(named: "icon")
//        cell.imageView.image = images[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath)
        cell.textLabel?.text = users[indexPath.row]
        cell.accessoryType = .none
        cell.imageView?.image = images[indexPath.row]
//        cell.imageView?.image = images
//        cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.height ?? 0) / 2
        cell.imageView?.clipsToBounds = true
        cell.imageView?.contentMode = .scaleAspectFit
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController(with: "cian364@gmail.com")
        vc.title = users[indexPath.row]
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

