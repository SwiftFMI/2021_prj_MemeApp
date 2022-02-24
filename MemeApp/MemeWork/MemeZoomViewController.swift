//
//  MemeZoomViewController.swift
//  MemeApp
//
//  Created by Nikola Laskov on 18.02.22.
//

import Foundation
import UIKit
import Zoomy
import Kingfisher

class MemeZoomViewController: UIViewController {

    @IBOutlet var safeButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        //Get selected image from gallery
        if let imageURL = StorageManager.shared.selecedImage {
            imageView.kf.setImage(with: imageURL)
            StorageManager.shared.selecedImage=nil
        }
        //If there isn`t image selected return to gallery
        else {
            print ("No image found!")
            _ = navigationController?.popViewController(animated: true)
            
        }
            //Make it zoomable
            addZoombehavior(for: imageView, settings: .instaZoomSettings);
        
        
    }
    
    @IBAction func pressButton(_ sender: Any) {
        let shareSheet = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
            
        present(shareSheet,animated: true);
        
    }
    
    @IBAction func safeButtonPressed(_ sender: Any){
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
           
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your meme has been saved to your photo gallery.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    


}

