//
//  AuthService.swift
//  TwiterApp
//
//  Created by 강민주 on 2023/02/28.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func registerUser(credential: AuthCredentials , completion: @escaping(Error?, DatabaseReference) -> Void) {
        let email = credential.email
        let password = credential.password
        let fullname = credential.fullname
        let username = credential.username
        
        
        guard let imageData = credential.profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { meta, error in
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {return}

                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Error is \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else {return}
                    
                    let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageUrl]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
