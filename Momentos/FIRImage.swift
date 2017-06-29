//
//  FIRImage.swift
//  Momentos
//
//  Created by Bruno Corrêa on 25/04/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import Foundation
import Firebase

class FIRImage{
    
    var image:UIImage
    var downloadURL: URL?
    var downloadLink:String!
    var ref:StorageReference!
    
    init(image:UIImage) {
        self.image = image
    }
}

extension FIRImage{
    
    func saveProfileImage(userUID:String,completion:@escaping (Error?) -> Void){
        
        let resized = image.resize()
        let imageData =  UIImageJPEGRepresentation(resized, 0.9)
        
        ref = StorageRef.profileImages.ref().child(userUID)
        downloadLink = ref.description
        
        ref.putData(imageData!, metadata: nil) { (metadData, error) in
           completion(error)
        }
    }
    
    func save(uid:String, completion:@escaping (Error?) -> Void){
        
        let resized = image.resize()
        let imageData =  UIImageJPEGRepresentation(resized, 0.9)
        
        ref = StorageRef.images.ref().child(uid)
        downloadLink = ref.description
        
        ref.putData(imageData!, metadata: nil) { (metadData, error) in
            completion(error)
        }

    }
}

extension FIRImage{
    
    class func downloadProfileImage(uid:String,completion:@escaping (UIImage?,Error?) -> Void){
        
        StorageRef.profileImages.ref().child(uid).getData(maxSize: 1*1024*1024) {(imageData, error) in
            if error == nil && imageData != nil{
                let image = UIImage(data: imageData!)
                completion(image,error)
            }else{
                completion(nil,error)
            }
        }
   }
    
    class func downloadImage(uid:String,completion:@escaping (UIImage?,Error?) -> Void){
        
        StorageRef.images.ref().child(uid).getData(maxSize: 1*1024*1024) {(imageData, error) in
            if error == nil && imageData != nil{
                let image = UIImage(data: imageData!)
                completion(image,error)
            }else{
                completion(nil,error)
            }
        }
    }
    
}

private extension UIImage{
    
    func resize() -> UIImage{
        let height: CGFloat = 800.0
        let ratio = self.size.width / self.size.height
        let width = height * ratio
        
        let newSize = CGSize(width:width,height:height)
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: newRectangle)
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
}
