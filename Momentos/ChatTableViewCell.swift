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
    
    var chat :Chat!{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        titleLabel.text = chat.title
        lastMessageLabel.text = chat.lastMessage
        chat.downloadFeaturedImage { (image, error) in
            self.featuredImageView.image = image
            self.featuredImageView.layer.cornerRadius = self.featuredImageView.bounds.width/2.0
            self.featuredImageView.layer.masksToBounds = true
        }
            
    }
}
