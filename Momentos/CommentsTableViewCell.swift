//
//  CommentsTableViewCell.swift
//  Momentos
//
//  Created by Bruno Corrêa on 21/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var usernameButtom:UIButton!
    @IBOutlet weak var commentsTextLabel:UILabel!
    
    var currentUser:User!
    var comment:Comments!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
      
        profileImageView.image = UIImage(named:"icon-defaultAvatar")
        comment.from.downloadProfilePicture { [weak self](image, error) in
            self?.profileImageView.image = image
        }
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2.0
        profileImageView.layer.masksToBounds = true
        usernameButtom.setTitle(comment.from.userName, for: [])
        commentsTextLabel.text = comment.caption
        
    }
}
