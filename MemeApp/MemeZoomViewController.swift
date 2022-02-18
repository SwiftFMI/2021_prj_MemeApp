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
            addZoombehavior(for: imageView);
    }


}

