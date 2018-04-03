//
//  ContactTableViewCell.swift
//  Momentos
//
//  Created by Bruno Corrêa on 04/07/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView:UIImageView!
    @IBOutlet weak var displayNameLabel:UILabel!
    @IBOutlet weak var checkboxImageView:UIImageView!
    @IBOutlet weak var emailTextLabel:UILabel!
    
    var user:User!{
        didSet{
            self.updateUI()
        }
    }
    
    var added:Bool = false{
        didSet{
            if added == false{
                checkboxImageView.image = UIImage(named: "icon-checkbox")
            }else{
                checkboxImageView.image = UIImage(named: "icon-checkbox-filled")
            }
        }
    }
    
    func updateUI(){
      user.downloadProfilePicture { (image, error) in
        if error != nil{
            self.profileImageView.image = UIImage(named:"icon-defaultAvatar")
        }else{
            self.profileImageView.image = image
        }
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2.0
        self.profileImageView.layer.masksToBounds = true
        }
        
        displayNameLabel.text = user.userName
        checkboxImageView.image = UIImage( named: "icon-checkbox")
        emailTextLabel.text = user.fullName
    }
    
}
