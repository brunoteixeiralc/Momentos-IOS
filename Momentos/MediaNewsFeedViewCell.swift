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

protocol MediaNewsFeedViewCellDelegate: class {
    func commentDidTap(media: Media)
    func seeCommentDidTap(media: Media)
}

class MediaNewsFeedViewCell: UITableViewCell {

    @IBOutlet weak var mediaImageView:UIImageView!
    @IBOutlet weak var captionLabel:UILabel!
    @IBOutlet weak var createdAtLabel:UILabel!
    @IBOutlet weak var likeButtom:UIButton!
    @IBOutlet weak var commentButtom:UIButton!
    @IBOutlet weak var shareButtom:UIButton!
    @IBOutlet weak var numberOfLikesButtom:UIButton!
    @IBOutlet weak var viewAllCommenstButtom:UIButton!
    
    var cache = SAMCache.shared()
    weak var delegate: MediaNewsFeedViewCellDelegate?
    
    let animationLike = LOTAnimationView(name: "like")
    let animationLoading = LOTAnimationView(name: "loading")
    
    var currentUser:User!
    var media:Media! {
        didSet{
            if currentUser != nil{
                self.updateUI()
            }
        }
    }
    
    func updateUI(){
        
        fetchComments()
        fetchLikes()
        fetchUnLikes()
        
        animationLike?.frame = CGRect(x: 0, y: 0, width: 201, height: 201)
        animationLike?.center = mediaImageView.center
        animationLoading?.frame = CGRect(x: 0, y: 0, width: 201, height: 201)
        animationLoading?.center = mediaImageView.center
        
        self.mediaImageView.image = nil
        
//        if let imageCache = self.cache?.object(forKey: "\(media.uid)-mediaImage") as? UIImage{
//            self.mediaImageView.image = imageCache
//
//        }else
        
        if let image = self.media.mediaImage{
            self.mediaImageView.image = image
       
        }else{
            animationLoading?.animationProgress = 0.0
            animationLoading?.loopAnimation = true
            addSubview((animationLoading)!)
            animationLoading?.play()
            
            media.downloadMediaImage { [weak self](image, error) in
                self?.mediaImageView.image = image
                self?.cache?.setObject(image, forKey: "\(String(describing: self?.media.uid))-mediaImage")
                self?.animationLoading?.removeFromSuperview()
            }
        }
        
        captionLabel.text = media.caption
        
        likeButtom.setImage(UIImage(named:"icon-like"), for: [])
        
        createdAtLabel.text = timeAgoDisplay(date: media.createdTime)
    }
    
    func fetchComments(){
        media.observeNewComment { (comment) in
           self.setComments()
        }
    }
    
    func fetchLikes(){
        media.observeNewLikes { (comment) in
            self.setLikesBy()
        }
    }
    
    func fetchUnLikes(){
        media.observeNewUnLikes { (comment) in
            self.setLikesBy()
        }
    }
    
    @IBAction func likesDidTap(){
        if media.likes.contains(currentUser){
            likeButtom.setImage(UIImage(named: "icon-like"), for: [])
            media.unlikedBy(user: currentUser)
        }else{
            media.likedBy(user: currentUser)
            self.likeButtom.setImage(UIImage(named: "icon-like-filled"), for: [])
            
            animationLike?.animationProgress = 0.0
            addSubview((animationLike)!)
            animationLike?.play(completion: { finished in
                self.animationLike?.removeFromSuperview()
            })
        }
    }
    
    @IBAction func seeCommentDidTap(){
        delegate?.seeCommentDidTap(media: media)
    }
    
    @IBAction func commentDidTap(){
        delegate?.commentDidTap(media: media)
    }
    
    @IBAction func shareDidTap(){
        
    }
    
    @IBAction func numberOfLikesDidTap(){
        
    }
    
}

extension MediaNewsFeedViewCell{
    
    func setComments(){
        if media.comments.count == 0{
            viewAllCommenstButtom.setTitle("Seja o primeiro a fazer um comentário", for: [])
        }else if media.comments.count == 1{
            viewAllCommenstButtom.setTitle("Veja o primeiro comentário", for: [])
        }else{
            viewAllCommenstButtom.setTitle("Veja os \(media.comments.count) comentários", for: [])
        }
    }
    
    func setLikesBy(){
        if media.likes.count == 0{
            numberOfLikesButtom.setTitle("Seja o primeiro a gostar deste momento", for: [])
        }else if media.likes.count == 1{
            numberOfLikesButtom.setTitle("♥️ Uma pessoa gostou", for: [])
        }else{
            numberOfLikesButtom.setTitle("♥️ \(media.likes.count) pessoas gostaram", for: [])
        }
        if media.likes.contains(currentUser){
            likeButtom.setImage(UIImage(named:"icon-like-filled"), for: [])
        }
    }
    
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

