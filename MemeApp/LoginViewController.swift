//
//  ViewController.swift
//  MemeApp
//
//  Created by Nikola Laskov on 12.01.22.
//

import UIKit
import Firebase
import FirebaseAuth
import NVActivityIndicatorView

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    let activity=NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .gray, padding: nil)
    
    @IBOutlet var segment: UISegmentedControl!
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var button: UIButton!
    @IBOutlet var Error: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //On tap to hide the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturnOnTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        email.delegate = self
        email.tag = 0
        password.delegate = self
        password.tag = 1
        
        activity.frame.size = CGSize(width: 100, height: 100)
        activity.center = view.center
        
        
    }
    
    @objc func textFieldShouldReturnOnTap(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          
          if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
             nextField.becomeFirstResponder()
          } else {
              self.buttonPressed(self)
          }
          
          return false
       }
    
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        Error.isHidden = true
        email.text = ""
        password.text = ""
        if segment.selectedSegmentIndex == 0 {
            button.setTitle("Login", for: .normal)
        }
        else {
            button.setTitle("Registration", for: .normal)
        }
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {
        self.Error.isHidden = true
        
        view.addSubview(activity);
        activity.startAnimating()
        
        if segment.selectedSegmentIndex == 0 {
            FirebaseAuthManager.shared.login(email: email.text, password: password.text) { success, error in
                if success{
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.Error.isHidden = false
                    self.errorSetter(error: error as! AuthError)
                }
                self.activity.stopAnimating();
                self.activity.removeFromSuperview()
                
            }
        }
        else {
            
            FirebaseAuthManager.shared.singUp(email: email.text, password: password.text) { success, error in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    self.Error.isHidden = false
                    self.errorSetter(error: error as! AuthError)
                }
                self.activity.stopAnimating();
                self.activity.removeFromSuperview()
                
            }
        }
    }
    
    func errorSetter(error: AuthError){
        if error == .defaultError {
           self.Error.text = "Something is wrong"
           
       } else if error == .noEmail {
            self.Error.text = "Email is required"
            
        } else if error == .noPassword {
            self.Error.text = "Password is required"
            
        } else if error == .noUser {
            self.Error.text = "Email or password incorect"
            
        } else if error == .invalidEmail {
            self.Error.text = "Invalid email"
            
        } else if error == .invalidEmail {
            self.Error.text = "Invalid email"
            
        } else if error == .emailAlreadyInUse {
            self.Error.text = "The email is already used"
            
        } else if error == .weakPassword {
            self.Error.text = "Password should be at least 6 characters"
            
        }
    }
    
    
    
   
    
    
    
    
    
    
    
}
