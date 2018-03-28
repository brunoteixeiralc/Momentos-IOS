//
//  Chat.swift
//  Momentos
//
//  Created by Bruno Corrêa on 03/07/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase


class Chat{
    
    var uid:String
    var ref:DatabaseReference
    var users:[User]
    var lastMessage:String
    var lastUpdate: Double
    var messageIds:[String]
    var title:String
    var featuredImageUID:String
    
    init(users:[User], title:String, featuredImageUID:String) {
        self.users = users
        self.title = title
        lastUpdate = Date().timeIntervalSince1970
        messageIds = []
        lastMessage = ""
        self.featuredImageUID = featuredImageUID
        
        ref = DatabaseRef.chats.ref().childByAutoId()
        uid = ref.key
    }
    
    init(dictionary: [String:Any]) {
        uid = dictionary["uid"] as! String
        lastMessage = dictionary["lastMessage"] as! String
        lastUpdate = dictionary["lastUpdate"] as! Double
        title = dictionary["title"] as! String
        ref = DatabaseRef.chats.ref().child(uid)
        featuredImageUID = dictionary["featuredImageUID"] as! String
        
        users = []
        if let usersDict = dictionary["users"] as? [String:Any]{
            for(_,userDict) in usersDict{
                if let userDict = userDict as? [String:Any]{
                    self.users.append(User(dictionary: userDict))
                }
            }
        }
        
        messageIds = []
        if let messageIdsDict = dictionary["messageIds"] as? [String:Any]{
            for(_,messageId) in messageIdsDict{
                if let messageId = messageId as? String{
                    self.messageIds.append(messageId)
                }
            }
        }
    }
    
    func save(){
        ref.setValue(toDictionary())
        
        let usersRef = ref.child("users")
        for user in users{
            usersRef.child(user.uid).setValue(user.toDictionary())
        }
        
        let messageIdsRef = ref.child("messageIds")
        for messageId in messageIds{
            messageIdsRef.childByAutoId().setValue(messageId)
        }
    }
    
    func toDictionary() -> [String:Any]{
        return [
            "uid":uid,
            "lastMessage":lastMessage,
            "lastUpdate":lastUpdate,
            "title":title,
            "featuredImageUID":featuredImageUID
        ]
    }
}

extension Chat
{
    func downloadFeaturedImage(completion:@escaping (UIImage?,Error?) ->Void)
    {
        FIRImage.downloadProfileImage(uid: self.featuredImageUID,completion:{
            (image,error) in
            completion(image,error)
        })
    }
    
    func send(message:Message){
        
        self.messageIds.append(message.uid)
        self.lastMessage = message.text
        self.lastUpdate = Date().timeIntervalSince1970
        
        ref.child("lastMessage").setValue(lastMessage)
        ref.child("lastUpdate").setValue(lastUpdate)
        ref.child("messageIds").childByAutoId().setValue(message.uid)
        
    }
}

extension Chat:Equatable{}

func == (lhs:Chat, rhs:Chat) -> Bool {
    return lhs.uid == rhs.uid
}

extension Chat{
    
class func observerChat(_ completion: @escaping (Chat) -> Void){
    DatabaseRef.chats.ref().observe(.childAdded, with: { (snapshot) in
        let chat = Chat(dictionary: snapshot.value as! [String:Any])
        completion(chat)
      })
  }
}

