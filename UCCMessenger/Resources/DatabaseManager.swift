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
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}

// MARK: - Account Management

extension DatabaseManager {
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        })
    }
    
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstname,
            "last_name": user.lastname
        ])
    }
    
//    func searchUsers(queryText: String, completion: @escaping ([String]) -> Void) {
//        database.child("users").getDocuments { snapshot, error in
//            guard let usernames = snapshot?.documents.compactMap({ $0.documentID }),
//                  error == nil else {
//                completion([])
//                return
//            }
//
//            let filtered = usernames.filter({
//                $0.lowercased().hasPrefix(queryText.lowercased())
//            })
//
//            completion(filtered)
//        }
//    }
}


// Mark: - Sending messages / conversation

extension DatabaseManager {
    
    public func createNewConversation(with otherUserEmail: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
//        let ref = datebase.child("\(safeEmail)")
//        ref.observeSingleEvent(of: .value, with: {snapshot in
//            guard let userNode = snapshot.value as? [String: Any] else {
//                completion(false)
//                print("User not found")
//                return
//            }
            
//            let messageDate = firstMessage.sentDate
//            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
//
//            var message = ""
//
//            switch firstMessage.kind {
//
//            }
//
//            let newConversationData: [String: Any] = [
//                "id": "conversation_\(firstMessage.messageIdv)",
//                "other_user_email": otherUserEmail,
//                "latest_message": [
//                    "date": dateString,
//                    "message": message,
//                    "is_read": false
//                ]
//            ]
//
//            if var conversations = userNode["conversations"] as? [[String: Any]] {
//
//            }
//            else {
//
//            }
//        })
//    }
//
//    public func getAllConversations(for email: String, completion: @escaping (Result<String, Error>) -> Void) {
//
//    }
//
//    public func getAllMessagesForConversation(with id: String, completion: @escaping (Result<String, Error>) -> Void) {
//
//    }
//
//    public func sendMessage( to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
//
    }
}
//extension AppStateModel {
//    
//}

struct ChatAppUser {
    let firstname: String
    let lastname: String
    let emailAddress: String
    //        let profilePictureUrl: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
        
    }
}
