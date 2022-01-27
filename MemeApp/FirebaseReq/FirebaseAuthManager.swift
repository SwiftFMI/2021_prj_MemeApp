//
//  FirebaseAuthManager.swift
//  MemeApp
//
//  Created by Nikola Laskov on 20.01.22.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthManager: NSObject {
    
    static let shared = FirebaseAuthManager()

    var currentUser: User?
    
    func login(email: String?, password: String? , completion: @escaping (_ success: Bool, _ error: Error?) -> () ){
        guard let email = email, !email.isEmpty else {
            completion(false, AuthError.noEmail)
            return
        }
        guard let password = password, !password.isEmpty else {
            completion(false, AuthError.noPassword)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

            guard let user = user , error == nil else {
                completion(false, AuthError.noUser)
                return
            }
            UserDefaults.standard.set(user.user.uid, forKey: "UID")
            self.currentUser = User(email: email , uid: user.user.uid)
            completion(true, nil)
        }
    }
    
    func singUp(email: String?, password: String? , completion: @escaping (_ success: Bool, _ error: Error?) -> () ) {
        guard let email = email, !email.isEmpty else {
            completion(false, AuthError.noEmail)
            return
        }
        guard let password = password, !password.isEmpty else {
            completion(false, AuthError.noPassword)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            guard let user = user , error == nil else {
                completion(false, AuthError.noUser)
                return
            }
            
            self.currentUser = User(email: email, uid: user.user.uid)
            self.login(email: email, password: password) { (success, error) in
                completion(success,error)
            }
        }
    }
}

enum AuthError: Error {
    case noEmail
    case noPassword
    case noUser
    case noServer
    
}
