//
//  User.swift
//  Momentos
//
//  Created by Bruno Corrêa on 25/04/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    let uid: String
    var userName:String
    var fullName:String
    var bio:String
    var website:String
    var profileImage:UIImage?
    
    var follows:[User]
    var followedBy: [User]
    
    init(uid:String,userName:String,fullName:String,bio:String,website:String,profileImage:UIImage?,follows:[User],followedBy:[User]) {
        
        self.uid = uid
        self.userName = userName
        self.fullName = fullName
        self.bio = bio
        self.website = website
        self.profileImage = profileImage
        self.follows = follows
        self.followedBy = followedBy
    
    }
    
    init(dictionary:[String:Any]) {
        
        uid = dictionary["uid"] as! String
        userName = dictionary["userName"] as! String
        fullName = dictionary["fullName"] as! String
        bio = dictionary["bio"] as! String
        website = dictionary["website"] as! String
        
        self.follows = []
        if let followDict = dictionary["follows"] as? [String:Any]{
            for(_,userDict) in followDict{
                if let userDict = userDict as? [String:Any]{
                    self.follows.append(User(dictionary:userDict))
                }
            }
        }
        
        self.followedBy = []
        if let followedByDict = dictionary["followedBy"] as? [String:Any]{
            for(_,userDict) in followedByDict{
                if let userDict = userDict as? [String:Any]{
                    self.followedBy.append(User(dictionary:userDict))
                }
            }
        }

    }

    func save(completion:@escaping (Error?) -> Void){
        
        let ref = DatabaseReference.user(uid:uid).ref()
        ref.setValue(toDictionary())
        
        for user in follows{
            ref.child("follows/\(user.uid)").setValue(user.toDictionary())
        }
        
        for user in followedBy{
            ref.child("followedBy/\(user.uid)").setValue(user.toDictionary())
        }
        
        if let profileImage = self.profileImage{
            
            let firImage = FIRImage(image: profileImage)
            firImage.saveProfileImage(userUID: self.uid, completion: { (error) in
                completion(error)
            })
            
        }
        
    }
    
    func toDictionary() -> [String:Any]{
        
        return [
            "uid": uid,
            "userName": userName,
            "fullName": fullName,
            "bio":bio,
            "website":website
        ]
    }
}

extension User {
    
    func share(newMedia:Media){
        DatabaseReference.user(uid: uid).ref().child("media").childByAutoId().setValue(newMedia.uid)
    }
    
    func downloadProfilePicture(completion: @escaping (UIImage?,NSError?) -> Void){
        FIRImage.downloadProfileImage(uid: uid) { (image, error) in
            self.profileImage = image
            completion(image,error as NSError?)
        }
    }
    
    func follow(user:User){
        self.follows.append(user)
        DatabaseReference.user(uid: uid).ref().child("follows").child(user.uid).setValue(user.toDictionary())
    }
    
    func unfollow(user:User){
        if let index = follows.index(of: user){
            follows.remove(at: index)
            DatabaseReference.user(uid: uid).ref().child("follows").child(user.uid).setValue(nil)
        }
    }

}

extension User:Equatable{}

func ==(lhs:User, rhs:User) -> Bool{
    return lhs.uid == rhs.uid
}
