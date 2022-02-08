//
//  TemplateViewController.swift
//  MemeApp
//
//  Created by Nikola Laskov on 21.01.22.
//

import UIKit
import Foundation
import Kingfisher
import NVActivityIndicatorView
import FirebaseAuth

class TemplatesViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var GelleryButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource=self;
        collectionView.delegate=self;
        
        //Create and position lloading animation
        let activity=NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .gray, padding: nil)
        activity.frame.size = CGSize(width: 100, height: 100)
        activity.center = view.center
        
        
        view.addSubview(activity);
        
        
        //Get templates
        if StorageManager.shared.templates.isEmpty {
            activity.startAnimating();
            
            StorageManager.shared.getFromFirebaseTemplates {
                self.collectionView.reloadData()
                //Stop loading animation after loading the templates
                activity.stopAnimating()
                activity.removeFromSuperview()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "login") as! LoginViewController
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    @IBAction func pressButton(_ sender: Any) {
        let vc = UIImagePickerController();
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue:"UIImagePickerControllerEditedImage")] as? UIImage{
            StorageManager.shared.uploadedTemplate = image
            
            performSegue(withIdentifier: "toMemeGenerator", sender: nil)
            
            //To dismiss the PickerController after segue
            dismiss(animated: true);
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension TemplatesViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return StorageManager.shared.templates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        let stringURL = StorageManager.shared.templates[indexPath.row]
        StorageManager.shared.selecedTemplate=URL(string: stringURL)
        
            performSegue(withIdentifier: "toMemeGenerator", sender: nil)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCollectionViewCell", for: indexPath) as! TemplateCollectionViewCell
        
        let url = URL(string: StorageManager.shared.templates[indexPath.row] )
        
        cell.image.kf.setImage(with: url)
                
            
        return cell
    }
    
}
