//
//  MediaTableViewCell.swift
//  Momentos
//
//  Created by Bruno Corrêa on 21/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaImageView:UIImageView!
    @IBOutlet weak var captionLabel:UILabel!
    @IBOutlet weak var createdAtLabel:UILabel!
    @IBOutlet weak var likeButtom:UIButton!
    @IBOutlet weak var commentButtom:UIButton!
    @IBOutlet weak var shareButtom:UIButton!
    @IBOutlet weak var numberOfLikesButtom:UIButton!
    @IBOutlet weak var viewAllCommenstButtom:UIButton!
    
    var currentUser:User!
    var media:Media! {
        didSet{
            if currentUser != nil{
                self.updateUI()
            }
        }
    }
    
    func updateUI(){
        
        self.mediaImageView.image = nil
        media.downloadMediaImage { [weak self](image, error) in
            self?.mediaImageView.image = image
        }
        
        captionLabel.text = media.caption
        likeButtom.setImage(UIImage(named:"icon-like"), for: [])
        
        if media.likes.count == 0{
            numberOfLikesButtom.setTitle("Seja o primeiro a gostar deste momento", for: [])
        }else{
            numberOfLikesButtom.setTitle("♥️ \(media.likes.count) gostaram", for: [])
            if media.likes.contains(currentUser){
                likeButtom.setImage(UIImage(named:"icon-like-filled"), for: [])
            }
        }
        
        if media.comments.count == 0{
            viewAllCommenstButtom.setTitle("Seja o primeiro a fazer um comentário", for: [])
        }else{
            viewAllCommenstButtom.setTitle("Veja os \(media.comments.count) comentários", for: [])
        }
    }
    
    @IBAction func likesDidTap(){
        
    }
    
    @IBAction func commentDidTap(){
        
    }
    
    @IBAction func shareDidTap(){
        
    }
    
    @IBAction func numberOfLikesDidTap(){
        
    }
    
    @IBAction func viewAllCommentsDidTap(){
        
    }
}

