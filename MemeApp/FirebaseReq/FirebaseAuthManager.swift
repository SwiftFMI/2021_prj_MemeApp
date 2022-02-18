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
    
    func login(email: String?, password: String? , completion: @escaping (_ success: Bool, _ error: Error?) -> () ){
        //Check for email
        guard let email = email, !email.isEmpty else {
            completion(false, AuthError.noEmail)
            return
        }
        //Check for password
        guard let password = password, !password.isEmpty else {
            completion(false, AuthError.noPassword)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in

            //If there is an error:
            if error != nil {
                
                switch (error! as NSError).code {
                case 17008:
                    completion(false, AuthError.invalidEmail)
                case 17011, 17009:
                    completion(false, AuthError.noUser)
                default:
                    completion(false, AuthError.defaultError)
                    print(error!.localizedDescription)
                }
                
                return
            }
            
            //If there isn`t error
            completion(true, nil)
        }
    }
    
    func logout(completion: (_ success: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        } catch {
            print(error)
            completion(false)
            return
        }
    }
    
    func singUp(email: String?, password: String? , completion: @escaping (_ success: Bool, _ error: Error?) -> () ) {
        //Check for email
        guard let email = email, !email.isEmpty else {
            completion(false, AuthError.noEmail)
            return
        }
        //Check for password
        guard let password = password, !password.isEmpty else {
            completion(false, AuthError.noPassword)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            //If there is an error
            if error != nil {
                
                switch (error! as NSError).code {
                case 17008:
                    completion(false, AuthError.invalidEmail)
                case 17007:
                    completion(false, AuthError.emailAlreadyInUse)
                case 17026:
                    completion(false, AuthError.weakPassword)
                default:
                    completion(false, AuthError.defaultError)
                    print(error!.localizedDescription)
                }
                
                return
            }
            
            //If there isn`t error
            completion(true, nil)
            
        }
    }
}

enum AuthError: Error {
    case noEmail
    case noPassword
    case noUser
    case invalidEmail
    case emailAlreadyInUse
    case weakPassword
    case defaultError
}
