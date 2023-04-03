//
//  AuthService.swift
//  TwitterClone
//
//  Created by Felipe Vieira Lima on 29/03/23.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseAuth

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func register(credentials: AuthCredentials, completion: @escaping((Error?, DatabaseReference) -> Void)) {
        let email = credentials.email
        let password = credentials.password
        let username = credentials.username
        let fullname = credentials.fullname
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let profileImageURL = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageURL]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
