//
//  ChangePasswordViewController.swift
//  MemeApp
//
//  Created by Marty Kostov on 24.02.22.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    
    @IBOutlet weak var OldPassword: UITextField!
    @IBOutlet weak var NewPassword: UITextField!
    @IBOutlet weak var Error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        self.Error.isHidden = true
        
        FirebaseAuthManager.shared.changePassword(oldPassword: OldPassword.text, newPassword: NewPassword.text) { success, error in
            if success {
                self.OldPassword.text = ""
                self.NewPassword.text = ""
                self.alertSuccess(sender)
            }
            else {
                self.Error.isHidden = false
                self.errorSetter(error: error as! AuthError)
            }
        }
        
    }
    
    func alertSuccess(_ sender: UIButton) {
        let alert = UIAlertController(title: "Changed Password", message:"You have successfully changed your password!", preferredStyle: .alert)
        
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
           
       } else if error == .noOldPassword {
            self.Error.text = "Old password is required"
            
        } else if error == .noNewPassword {
            self.Error.text = "New password is required"
            
        } else if error == .incorrectPassword {
            self.Error.text = "Incorrect Password"
            
        } else if error == .weakPassword {
            self.Error.text = "Password should be at least 6 characters"
            
        }
    }
    

}
