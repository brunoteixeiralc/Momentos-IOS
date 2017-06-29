//
//  Media.swift
//  Momentos
//
//  Created by Bruno Corrêa on 07/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit

class Media{
    
    var uid:String
    var type:String //image ou video
    var caption:String
    var createdTime:Double
    var createdBy: User
    var likes: [User]
    var comments: [Comments]
    var mediaImage: UIImage?
    
    init(type:String,caption:String,createdBy:User,mediaImage:UIImage) {
        self.type = type
        self.caption = caption
        self.createdBy = createdBy
        self.mediaImage = mediaImage
        
        createdTime = Date().timeIntervalSince1970
        comments = []
        likes = []
        uid = DatabaseRef.media.ref().childByAutoId().key
        
    }
    
    init(dictionary:[String:Any]){
        
        uid = dictionary["uid"] as! String
        type = dictionary["type"] as! String
        caption = dictionary["caption"] as! String
        createdTime = dictionary["createdTime"] as! Double
        
        let createdByDict = dictionary["createBy"] as! [String:Any]
        createdBy = User(dictionary: createdByDict)
        
        likes = []
        if let likesDict = dictionary["likes"] as? [String:Any] {
            print("likes - \(likesDict.count)")
            
            for(_,userDict) in likesDict {
                if let userDict = userDict as? [String:Any] {
                    likes.append(User(dictionary: userDict))
                }
            }
        }
        
        comments = []
        if let commentsDict = dictionary["comments"] as? [String:Any]{
            print("comments - \(commentsDict.count)")
            
            for(_,commentDict) in commentsDict {
                if let commentDict = commentDict as? [String:Any] {
                    comments.append(Comments(dictionary: commentDict))
                }
            }

        }
    }
    
    func save(completion:@escaping (Error?) -> Void){
        
        let ref = DatabaseRef.media.ref().child(self.uid)
        ref.setValue(toDictionary())
        
        for like in likes{
            ref.child("likes").child(like.uid).setValue(like.toDictionary())
        }
        
        for comment in comments{
            ref.child("comments").child(comment.uid).setValue(comment.toDictionary())
        }

        if let mediaImage = self.mediaImage{
            let firImage = FIRImage(image: mediaImage)
            firImage.save(uid: self.uid, completion: { (error) in
                completion(error)
            })
        }
    }
    
    func toDictionary() -> [String:Any]{
        
        return[
            "uid":uid,
            "type":type,
            "caption":caption,
            "createdTime":createdTime,
            "createBy":createdBy.toDictionary()
        ]
    }
    
}

extension Media{
    
    func downloadMediaImage(completion: @escaping (UIImage?,Error?) -> Void){
        FIRImage.downloadImage(uid: uid) { (mediaImage, error) in
            completion(mediaImage,error)
        }
    }
    
    class func observerMedia(_ completion: @escaping (Media) -> Void){
        DatabaseRef.media.ref().observe(.childAdded, with: { (snapshot) in
            let media = Media(dictionary: snapshot.value as! [String:Any])
            completion(media)
        })
    }
    
    func observeNewComment(_ completion :@escaping (Comments) -> Void){
        DatabaseRef.media.ref().child(uid).child("comments").observe(.childAdded, with: { (snapshot) in
            let comment = Comments(dictionary: snapshot.value as! [String:Any])
            completion(comment)
        })
    }
    
    func likedBy(user:User){
        DatabaseRef.media.ref().child(uid).child("likes").child(user.uid).setValue(user.toDictionary())
    }
    
    func unlikedBy(user:User){
        if let index = likes.index(of: user){
            likes.remove(at: index)
            DatabaseRef.media.ref().child(uid).child("likes").child(user.uid).setValue(nil)
        }
    }
}

extension Media:Equatable{}

func ==(lhs:Media, rhs:Media) -> Bool{
    return lhs.uid == rhs.uid
}


