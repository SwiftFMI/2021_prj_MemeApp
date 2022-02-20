//
//  MyGalleryViewController.swift
//  MemeApp
//
//  Created by Nikola Laskov on 20.02.22.
//

import UIKit
import Foundation
import NVActivityIndicatorView
import Zoomy

class MyGalleryViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let activity=NVActivityIndicatorView(frame: .zero, type: .ballSpinFadeLoader, color: .gray, padding: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource=self;
        collectionView.delegate=self;
        
        //Position loading animation
        activity.frame.size = CGSize(width: 100, height: 100)
        activity.center = view.center
        
        //Start loading animation
        view.addSubview(activity);
        
        
        //Get templates
        if StorageManager.shared.memes.isEmpty {
            activity.startAnimating();
            StorageManager.shared.getFromFirebaseMyMemes {
                self.collectionView.reloadData()
                
                //Stop loading animation after loading the memes
                self.activity.stopAnimating()
                self.activity.removeFromSuperview()
                
            }
        }
        
        
    }
}

extension MyGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //Get number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return StorageManager.shared.memes.count
    }
    
    //Set cells with memes
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        
        let url = URL(string: StorageManager.shared.memes[indexPath.row] )
        
        cell.image.kf.setImage(with: url)
        addZoombehavior(for: cell.image, settings: .instaZoomSettings)
            
        return cell
    }
    
    //Send selected meme to MemeZoomViewController
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        let stringURL = StorageManager.shared.memes[indexPath.row]
        StorageManager.shared.selecedImage=URL(string: stringURL)
        
            performSegue(withIdentifier: "toMemeZoom", sender: nil)
    }
}


