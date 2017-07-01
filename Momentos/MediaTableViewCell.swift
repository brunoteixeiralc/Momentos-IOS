//
//  MediaTableViewCell.swift
//  Momentos
//
//  Created by Bruno Corrêa on 21/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import SAMCache
import Lottie

protocol MediaTableViewCellDelegate: class {
    func commentDidTap(media: Media)
}

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaImageView:UIImageView!
    @IBOutlet weak var captionLabel:UILabel!
    @IBOutlet weak var createdAtLabel:UILabel!
    @IBOutlet weak var likeButtom:UIButton!
    @IBOutlet weak var commentButtom:UIButton!
    @IBOutlet weak var shareButtom:UIButton!
    @IBOutlet weak var numberOfLikesButtom:UIButton!
    @IBOutlet weak var viewAllCommenstButtom:UIButton!
    
    var cache = SAMCache.shared()
    weak var delegate: MediaTableViewCellDelegate?
    
    let animationView = LOTAnimationView(name: "like")
    
    var currentUser:User!
    var media:Media! {
        didSet{
            if currentUser != nil{
                self.updateUI()
            }
        }
    }
    
    func updateUI(){
        
        animationView?.frame = CGRect(x: 0, y: 0, width: 201, height: 201)
        animationView?.center = mediaImageView.center
        
        self.mediaImageView.image = nil
        
        if let image = self.cache?.object(forKey: "\(media.uid)-mediaImage") as? UIImage{
            self.mediaImageView.image = image
        }else{
            media.downloadMediaImage { [weak self](image, error) in
                self?.mediaImageView.image = image
                self?.cache?.setObject(image, forKey: "\(String(describing: self?.media.uid))-mediaImage")
            }
        }
        
        captionLabel.text = media.caption
        likeButtom.setImage(UIImage(named:"icon-like"), for: [])
        
        if media.likes.count == 0{
            numberOfLikesButtom.setTitle("Seja o primeiro a gostar deste momento", for: [])
        }else if media.likes.count == 1{
            numberOfLikesButtom.setTitle("♥️ \(media.likes.count) gostou", for: [])
        }else{
            numberOfLikesButtom.setTitle("♥️ \(media.likes.count) gostaram", for: [])
        }
        if media.likes.contains(currentUser){
            likeButtom.setImage(UIImage(named:"icon-like-filled"), for: [])
        }
        
        if media.comments.count == 0{
            viewAllCommenstButtom.setTitle("Seja o primeiro a fazer um comentário", for: [])
        }else if media.comments.count == 1{
            viewAllCommenstButtom.setTitle("Veja o primeiro comentário", for: [])
        }else{
            viewAllCommenstButtom.setTitle("Veja os \(media.comments.count) comentários", for: [])
        }
    }
    
    @IBAction func likesDidTap(){
        if media.likes.contains(currentUser){
            likeButtom.setImage(UIImage(named: "icon-like"), for: [])
            media.unlikedBy(user: currentUser)
        }else{
            media.likedBy(user: currentUser)
            self.likeButtom.setImage(UIImage(named: "icon-like-filled"), for: [])
            
            animationView?.animationProgress = 0.0
            addSubview((animationView)!)
            animationView?.play(completion: { finished in
                self.animationView?.removeFromSuperview()
            })
        }
    }
    
    @IBAction func commentDidTap(){
        delegate?.commentDidTap(media: media)
    }
    
    @IBAction func shareDidTap(){
        
    }
    
    @IBAction func numberOfLikesDidTap(){
        
    }
    
    @IBAction func viewAllCommentsDidTap(){
        
    }
}

