//
//  DatabaseManager.swift
//  UCCMessenger
//
//  Created by Cian Keeney on 10/1/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database(url: "https://ucc-messenger-b5b64-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
    
}

// MARK: - Account Management

extension DatabaseManager {
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstname,
            "last_name": user.lastname
        ])
    }
    
    
    
}

struct ChatAppUser {
    let firstname: String
    let lastname: String
    let emailAddress: String
    //        let profilePictureUrl: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = emailAddress.replacingOccurrences(of: "@", with: "-")
        return safeEmail
        
    }
}
