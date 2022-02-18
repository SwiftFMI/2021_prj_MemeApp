//
//  FirebaseStorageManager.swift
//  MemeApp
//
//  Created by Nikola Laskov on 20.01.22.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth


final class StorageManager: NSObject {
    
    static let shared = StorageManager()
    

    private var templatesRef = Storage.storage().reference().child("Templates")
    private var memesRef = Storage.storage().reference().child("Memes")
    
    
    var templates: [String] = []
    var memes: [String] = []
    
    var selecedImage:URL? = nil
    var uploadedTemplate:UIImage? = nil
    
    func getFromFirebaseTemplates(completion: @escaping () -> () ) {
        
            templatesRef.listAll { (result, error) in
                
                if let error = error {
                    print(error)
                }
                var count = result.items.count
                for item in result.items {
                    
                    item.downloadURL { url, error in
                        if let error = error {
                            print(error)
                            
                        } else {
                            guard let url = url else {
                                return
                            }
                            self.templates.append(url.absoluteString)
                            count -= 1
                            if count == 0 {
                                completion()
                            }
                        }
                    }
                }
        }
        
        
    }
    
    
    func getFromFirebaseMemes(completion: @escaping () -> () ) {
        memes.removeAll()
        memesRef.listAll { (result, error) in
            
            if let error = error {
                print(error)
            }
            var count = result.items.count
            for item in result.items {
                
                item.downloadURL { url, error in
                    if let error = error {
                        print(error)
                        
                    } else {
                        guard let url = url else {
                            return
                        }
                        self.memes.append(url.absoluteString)
                        count -= 1
                        if count == 0 {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func getFromFirebaseMyMemes(completion: @escaping () -> () ) {
        memes.removeAll()
        memesRef.listAll { (result, error) in
            
            if let error = error {
                print(error)
            }
            var count = result.items.count
            for item in result.items {
                
                item.downloadURL { url, error in
                    if let error = error {
                        print(error)
                        
                    } else {
                        guard let url = url else {
                            return
                        }
                        if (url.absoluteString.range(of: Auth.auth().currentUser!.uid) != nil){
                            self.memes.append(url.absoluteString)
                        }
                        count -= 1
                        if count == 0 {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func saveMemeInFirebase(memedImage: UIImage) {
        let memeRef = memesRef.child("\(NSUUID().uuidString).\(Auth.auth().currentUser?.uid ?? "").png")
        
        let imageData = memedImage.pngData()
        let _ = memeRef.putData(imageData!, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
            print(error as Any)
                return
            }}
    }
    
}
