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
        uid = DatabaseReference.media.ref().childByAutoId().key
        
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
            for(_,userDict) in likesDict {
                if let userDict = userDict as? [String:Any] {
                    likes.append(User(dictionary: userDict))
                }
            }
        }
        
        comments = []
    }
    
    func save(completion:@escaping (Error?) -> Void){
        
        let ref = DatabaseReference.media.ref().child(self.uid)
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
}

extension Media{
    
    class func observerMedia(_ completion: @escaping (Media) -> Void){
        
        DatabaseReference.media.ref().observe(.childAdded, with: { (snapshot) in
            let media = Media(dictionary: snapshot.value as! [String:Any])
            completion(media)
        })
    }
}

extension Media:Equatable{}

func ==(lhs:Media, rhs:Media) -> Bool{
    return lhs.uid == rhs.uid
}


