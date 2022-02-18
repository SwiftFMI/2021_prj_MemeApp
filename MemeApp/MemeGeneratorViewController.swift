//
//  MemeGeneratorViewController.swift
//  MemeApp
//
//  Created by Nikola Laskov on 21.01.22.
//

import Foundation
import UIKit
import Kingfisher


class MemeGeneratorViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var UpperText: UITextField!
    @IBOutlet var LowerText: UITextField!
    @IBOutlet var SaveButton: UIButton!
    @IBOutlet var FontSizeButton: UIButton!
    //@IBOutlet var FontSizes: UIMenu!
    @IBOutlet var FontStyleButton: UIButton!
    //@IBOutlet var FontStyles: UIMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURL = StorageManager.shared.selecedImage {
            image.kf.setImage(with: imageURL)
            StorageManager.shared.selecedImage=nil
        }
        else {
            image.image=StorageManager.shared.uploadedTemplate
            StorageManager.shared.uploadedTemplate=nil
        }
        // Do any additional setup after loading the view.
        
        
        //On tap to hide the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(textFieldShouldReturn))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //Screen to move with keyboard
        subscribeToKeyboardNotifications()
        
        self.UpperText.delegate = self
        self.LowerText.delegate = self
    }
    
    //Save the meme and return to TemplateViewController
    @IBAction func SaveButtonPress(_ sender: Any) {
        let memedImage = generateMemedImage()
        
        StorageManager.shared.saveMemeInFirebase(memedImage: memedImage)
        
        _ = navigationController?.popViewController(animated: true)
        
        //let shareSheet = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        //present(shareSheet,animated: true);
    }
    
    //Generate the meme
    func generateMemedImage() -> UIImage {
            
        //Hide buttons
        self.navigationController?.isNavigationBarHidden=true;
        SaveButton.isHidden=true;
        if UpperText.text=="Text" {
            UpperText.isHidden=true
        }
        if LowerText.text=="Text" {
            LowerText.isHidden=true
        }
        let backColor=view.backgroundColor;
        view.backgroundColor=image.backgroundColor
        
        //Get image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
            
        //Show buttons
            
        self.navigationController?.isNavigationBarHidden=false
        SaveButton.isHidden=false
        UpperText.isHidden=false
        LowerText.isHidden=false
        view.backgroundColor=backColor
        
        return memedImage
    }
    
    //On tap to hide the keyboard
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }

    //Screen to move with keyboard
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        // move the screen if keyboard shown for bottom text field
        if  UpperText.text == "Text" {
            UpperText.text = ""
        }
        
        if LowerText.isFirstResponder {
            if LowerText.text == "Text" {
                LowerText.text = ""
            }
            
            
            guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            
            if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
                view.frame.origin.y = 0-keyboardRect.height
            } else {
                view.frame.origin.y = 0
            }
        }
        
        
    }
    
    
   /* @IBAction func changeFont(_ sender: Any) {
        FontSizes.forEach{ (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum Fonts: String {
        case f1 = "F1"
        case f2 = "F2"
        case f3 = "F3"
        case f4 = "F4"
        case f5 = "F5"
    }
    
    @IBAction func chooseFont(_ sender: UIButton) {
        guard let title = sender.currentTitle, let font = Fonts(rawValue: title) else {
            return
        }
        
        switch font {
        case .f1:
            topTextField.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
            bottomTextField.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
        case .f2:
            topTextField.font = UIFont(name: "Copperplate", size: 40)
            bottomTextField.font = UIFont(name: "Copperplate", size: 40)
        case .f3:
            topTextField.font = UIFont(name: "GillSans-Italic", size: 40)
            bottomTextField.font = UIFont(name: "GillSans-Italic", size: 40)
        case .f4:
            topTextField.font = UIFont(name: "MarkerFelt-Wide", size: 40)
            bottomTextField.font = UIFont(name: "MarkerFelt-Wide", size: 40)
        case .f5:
            topTextField.font = UIFont(name: "TamilSangamMN-Bold", size: 40)
            bottomTextField.font = UIFont(name: "TamilSangamMN-Bold", size: 40)
        }
    }*/
    
    
}
