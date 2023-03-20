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
    
    func fetchUser(uid: String, completion: @escaping(User)->Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User])->Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
}
