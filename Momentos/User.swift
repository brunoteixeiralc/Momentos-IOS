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
    var profile:UIImage?
    
    var follows:[User]
    var followedBy: [User]
    
    init(uid:String,userName:String,fullName:String,bio:String,website:String,profile:UIImage,follows:[User],followedBy:[User]) {
        
        self.uid = uid
        self.userName = userName
        self.fullName = fullName
        self.bio = bio
        self.website = website
        self.profile = profile
        self.follows = follows
        self.followedBy = followedBy
    
    }
    
    func save(){
        
        let ref = DatabaseReference.user(uid:uid).ref()
        ref.setValue(toDictionary())
        
        for user in follows{
            ref.child("follows/\(user.uid)").setValue(user.toDictionary())
        }
        
        for user in followedBy{
            ref.child("followedBy/\(user.uid)").setValue(user.toDictionary())
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
