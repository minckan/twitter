//
//  UserService.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/28.
//

import FirebaseAuth
import FirebaseDatabase

struct UserService {
    static let shared = UserService()
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            guard let username = dictionary["username"] as? String else {return}
            print("DEBUG: username is \(username)")
        }
    }
}
