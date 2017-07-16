//
//  ChatTableViewCell.swift
//  Momentos
//
//  Created by Bruno Corrêa on 04/07/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var featuredImageView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var lastMessageLabel:UILabel!
    @IBOutlet weak var dateAndTime:UILabel!
    
    let now = Date()
    
    var chat :Chat!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        dateAndTime.text = timeAgoDisplay(date: chat.lastUpdate)
        titleLabel.text = chat.title
        lastMessageLabel.text = chat.lastMessage
        chat.downloadFeaturedImage { (image, error) in
            self.featuredImageView.image = image
            self.featuredImageView.layer.cornerRadius = self.featuredImageView.bounds.width/2.0
            self.featuredImageView.layer.masksToBounds = true
        }
        
    }
}

extension ChatTableViewCell{
    
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
