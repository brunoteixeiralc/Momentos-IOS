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
    @IBOutlet weak var createdAtLabel:UILabel!
    
    var currentUser:User!
    var comment:Comments!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){

        comment.from.downloadProfilePicture { [weak self](image, error) in
            if error != nil{
                self?.profileImageView.image = UIImage(named:"icon-defaultAvatar")
            }else{
                self?.profileImageView.image = image
            }
        }
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2.0
        profileImageView.layer.masksToBounds = true
        usernameButtom.setTitle(comment.from.userName, for: [])
        commentsTextLabel.text = comment.caption
        createdAtLabel.text = timeAgoDisplay(date: comment.createdTime)
        
    }
}

extension CommentsTableViewCell{
    
    func timeAgoDisplay(date: Double) -> String {
        let secondsAgo = Int(Date().timeIntervalSince(Date(timeIntervalSince1970: date)))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "\(secondsAgo) segundos atrás"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutos atrás"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) horas atrás"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) dias atrás"
        }
        
        return "\(secondsAgo / week) semanas atrás"
    }
}
