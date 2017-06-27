//
//  MediaHeaderCell.swift
//  Momentos
//
//  Created by Bruno Corrêa on 21/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import SAMCache

class MediaHeaderCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var usernameButtom:UIButton!
    @IBOutlet weak var followButtom:UIButton!

    var cache = SAMCache.shared()
    var currentUser:User!
    var media:Media!{
        didSet{
            if currentUser != nil{
                self.updateUI()
            }
        }
    }
    
   func updateUI(){
    
     profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
    
     if let image = cache?.object(forKey: "\(media.createdBy.uid)-headerImage") as? UIImage{
        self.profileImageView.image = image
     
     }else{
        media.createdBy.downloadProfilePicture { [weak self] (image, error) in
            if let image = image{
                self?.profileImageView.image = image
                self?.cache?.setObject(image, forKey: "\(String(describing: self?.media.createdBy.uid))-headerImage")
            }else if error != nil {
                print(error!)
            }
        }
    }
    
    profileImageView.layer.cornerRadius = profileImageView.bounds.width/2.0
    profileImageView.layer.masksToBounds = true
    
    usernameButtom.setTitle(media.createdBy.userName, for: [])
    
    followButtom.layer.borderWidth = 1
    followButtom.layer.cornerRadius = 2.0
    followButtom.layer.borderColor = followButtom.tintColor.cgColor
    followButtom.layer.masksToBounds = true
    if currentUser.follows.contains(media.createdBy) || media.createdBy.uid == currentUser.uid{
        followButtom.isHidden = true
    }else{
        followButtom.isHidden = false
    }
    
   }
    
   @IBAction func followDidTap(){
      followButtom.layer.borderWidth = 1
      followButtom.layer.cornerRadius = 2.0
      followButtom.layer.borderColor = followButtom.tintColor.cgColor
      followButtom.layer.masksToBounds = true
        
      if currentUser.follows.contains(media.createdBy){
            followButtom.setTitle("  Seguir  ", for: [])
            currentUser.unfollow(user: media.createdBy)
      }else{
            followButtom.setTitle("  Seguindo  ", for: [])
            currentUser.follow(user: media.createdBy)
    }
  }

}
