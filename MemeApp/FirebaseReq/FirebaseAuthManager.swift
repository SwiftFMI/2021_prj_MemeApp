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
    
    func changeEmail(newEmail: String?, password: String? , completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        
        //Check for email
        guard let newEmail = newEmail, !newEmail.isEmpty else {
            completion(false, AuthError.noEmail)
            return
        }
        //Check for password
        guard let password = password, !password.isEmpty else {
            completion(false, AuthError.noPassword)
            return
        }
        
        let user = Auth.auth().currentUser!
        let oldEmail = user.email!
        
        let credential = EmailAuthProvider.credential(withEmail: oldEmail, password: password)
        
        user.reauthenticate(with: credential) { _, error in
            //If there is an error
            if error != nil {
                switch (error! as NSError).code {
                case 17009:
                    completion(false, AuthError.incorrectPassword)
                default:
                    completion(false, AuthError.defaultError)
                    print(error!.localizedDescription)
                }
                
                return
                
            } else {
                user.updateEmail(to: newEmail) { error in
                    //If there is an error
                    if error != nil {
                        switch (error! as NSError).code {
                        case 17008:
                            completion(false, AuthError.invalidEmail)
                        case 17007:
                            completion(false, AuthError.emailAlreadyInUse)
                        default:
                            completion(false, AuthError.defaultError)
                            print(error!.localizedDescription)
                        }
                        
                        return
                       
                   } else {
                       //If there isn`t error
                       completion(true, nil)
                   }
                }
            }
        }
    }
    
    func changePassword(oldPassword: String?, newPassword: String? , completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        
        //Check for old password
        guard let oldPassword = oldPassword, !oldPassword.isEmpty else {
            completion(false, AuthError.noOldPassword)
            return
        }
        
        //Check for new password
        guard let newPassword = newPassword, !newPassword.isEmpty else {
            completion(false, AuthError.noNewPassword)
            return
        }
        
        let user = Auth.auth().currentUser!
        let email = user.email!
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
        
        user.reauthenticate(with: credential) { _, error in
            //If there is an error
            if error != nil {
                switch (error! as NSError).code {
                case 17009:
                    completion(false, AuthError.incorrectPassword)
                default:
                    completion(false, AuthError.defaultError)
                    print(error!.localizedDescription)
                }
                
                return
                
            } else {
                user.updatePassword(to: newPassword) { error in
                    //If there is an error
                    if error != nil {
                        switch (error! as NSError).code {
                        case 17026:
                            completion(false, AuthError.weakPassword)
                        default:
                            completion(false, AuthError.defaultError)
                            print(error!.localizedDescription)
                        }
                        
                        return
                       
                   } else {
                       //If there isn`t error
                       completion(true, nil)
                   }
                }
            }
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
    case incorrectPassword
    case noOldPassword
    case noNewPassword
}
