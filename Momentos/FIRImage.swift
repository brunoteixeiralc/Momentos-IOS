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
    var ref:FIRStorageReference!
    
    init(image:UIImage) {
        self.image = image
    }
}

extension FIRImage{
    
    func saveProfileImage(userUID:String,completion:@escaping (Error?) -> Void){
        
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
