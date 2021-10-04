//
//  DatabaseManager.swift
//  MessengerV2
//
//  Created by Trần Lễ on 10/3/21.
//

import Foundation

import FirebaseDatabase


final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}

//MARK: - Account Management
extension DatabaseManager {
    
    public func userExists(with email: String,
                           completion: @escaping ((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    //Add new user to Database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
            "password": user.password
        ])
    }
}


struct ChatAppUser {
    let emailAddress: String
    let firstName: String
    let lastName: String
    let password: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    //let profilePictureUrl: String
}
