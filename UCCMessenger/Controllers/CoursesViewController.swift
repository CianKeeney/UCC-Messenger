//
//  ProfileViewController.swift
//  UCCMessenger
//
//  Created by Cian Keeney on 10/1/22.
//

import UIKit

struct Courses: Codable {
    let name: String
}

class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    struct Constrants {
        static let coursesUrl = URL(string: "")
    }
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var courses: [Courses] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        fetch()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    func fetch() {
        URLSession.shared.request(
            url: Constrants.coursesUrl,
            expecting: [Courses].self
            ) { [weak self] result in
                switch result {
                case .success(let courses):
                    DispatchQueue.main.async {
                        self?.courses = courses
                        self?.table.reloadData()
                        print("SUCCESS - Courses")
                    }
                case . failure(let error):
                    print(error)
                }
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = courses[indexPath.row].name
        cell.backgroundColor = UIColor.systemBackground
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Cian Keeney"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
 
}

extension URLSession {
    enum CustomErrorCourses: Error {
        case invalidUrl
        case invalidData
    }
    
    func requestCourses<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping  (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        
        let task = dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
       task.resume()
    }
}
