//
//  ProfileViewController.swift
//  MemeApp
//
//  Created by Marty Kostov on 7.02.22.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func logout(_ sender: UIButton) {
        let alert = UIAlertController(title: "Log Out", message:"Are you sure you want to log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            FirebaseAuthManager.shared.logout { success in
                if (success) {
                    self.goToLogoutScene()
                    StorageManager.shared.memes.removeAll()
                    StorageManager.shared.myMemes.removeAll()
                }
            }
        }))
        
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = sender.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func goToLogoutScene() {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
            self.tabBarController?.selectedIndex = 0
    }
}
