//
//  ProfileViewController.swift
//  UCCMessenger
//
//  Created by Cian Keeney on 10/1/22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    
    @IBAction func LogOutBtn(_ sender: UIBarButtonItem) {
        
               do {
                   try FirebaseAuth.Auth.auth().signOut()
       
                   let vc = LoginViewController()
                   let nav = UINavigationController(rootViewController: vc)
                   nav.modalPresentationStyle = .fullScreen
                   present(nav, animated: false)
               }
               catch {
                   print("Failed to logout")
               }
    }
    @IBOutlet var tableView: UITableView!
    
    // testing
    let data = ["Name: Cian Keeney", "Course: Computer Science", "Modules: CS4000, CS4020, CS4040, CS4060", "School: Student's University", "DOB: 03/17/2001"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

               // Do any additional setup after loading the view.
    }
    


}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 10

        return cell
    }
}
