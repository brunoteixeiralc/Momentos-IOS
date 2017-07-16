//
//  Message.swift
//  Momentos
//
//  Created by Bruno Corrêa on 03/07/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import UIKit
import Firebase

public struct MessageType{
    static let text = "text"
    static let image = "image"
    static let video = "video"
}

class Message{
    
    var ref:DatabaseReference
    var uid:String
    var senderDisplayName:String
    var senderUID:String
    var lastUpdate:Date
    var type:String
    var text:String
    
    init(senderUID:String, senderDisplayName:String, type:String , text:String) {
        ref = DatabaseRef.messages.ref().childByAutoId()
        uid = ref.key
        self.senderDisplayName = senderDisplayName
        self.senderUID = senderUID
        self.type = type
        self.lastUpdate = Date()
        self.text = text
    }
    
    init(dictionary:[String:Any]) {
        uid = dictionary["uid"] as! String
        ref = DatabaseRef.messages.ref().child(uid)
        senderDisplayName = dictionary["senderDisplayName"] as! String
        senderUID = dictionary["senderUID"] as! String
        lastUpdate = Date(timeIntervalSince1970: dictionary["lastUpdate"] as! Double)
        type = dictionary["type"] as! String
        text = dictionary["text"] as! String
    }
    
    func save(){
       ref.setValue(toDictionary())
    }
    
    func toDictionary() -> [String:Any]{
        return [
            "uid":uid,
            "senderDisplayName":senderDisplayName,
            "senderUID":senderUID,
            "lastUpdate":lastUpdate.timeIntervalSince1970,
            "type":type,
            "text":text
        ]
    }
}

extension Message:Equatable {}

func ==(lhs:Message,rhs:Message) -> Bool{
    return lhs.uid == rhs.uid
}
