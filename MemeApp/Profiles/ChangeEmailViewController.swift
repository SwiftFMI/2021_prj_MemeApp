//
//  ChangeEmailViewController.swift
//  MemeApp
//
//  Created by Marty Kostov on 24.02.22.
//

import UIKit

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var NewEmail: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeEmail(_ sender: UIButton) {
        self.Error.isHidden = true
        
        FirebaseAuthManager.shared.changeEmail(newEmail: NewEmail.text, password: Password.text) { success, error in
            if success {
                self.NewEmail.text = ""
                self.Password.text = ""
                self.alertSuccess(sender)
            }
            else {
                self.Error.isHidden = false
                self.errorSetter(error: error as! AuthError)
            }
        }
    }
    
    
    func alertSuccess(_ sender: UIButton) {
        let alert = UIAlertController(title: "Changed Email", message:"You have successfully changed your email!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    func errorSetter(error: AuthError){
        if error == .defaultError {
           self.Error.text = "Something is wrong"
           
       } else if error == .noEmail {
            self.Error.text = "Email is required"
            
        } else if error == .noPassword {
            self.Error.text = "Password is required"
            
        } else if error == .incorrectPassword {
            self.Error.text = "Incorrect Password"
            
        } else if error == .invalidEmail {
            self.Error.text = "Invalid email"
            
        } else if error == .emailAlreadyInUse {
            self.Error.text = "The email is already used"
            
        }
    }
}

