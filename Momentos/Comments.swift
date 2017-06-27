//
//  Comments.swift
//  Momentos
//
//  Created by Bruno Corrêa on 07/06/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import Foundation
import Firebase

class Comments{
    
    var uid:String
    var mediaUid:String
    var createdTime:Double
    var from:User
    var caption:String
    var ref:FIRDatabaseReference
    
    init(mediaUid:String,from:User,caption:String) {
        self.mediaUid = mediaUid
        self.from = from
        self.caption = caption
        
        self.createdTime = Date().timeIntervalSince1970
        ref = DatabaseReference.media.ref().child(mediaUid).child("comments").childByAutoId()
        uid = ref.key
    }
    
    init(dictionary:[String:Any]) {
        
        uid = dictionary["uid"] as! String
        createdTime = dictionary["createdTime"] as! Double
        caption = dictionary["caption"] as! String
        
        let fromDictionary = dictionary["from"] as! [String:Any]
        from = User(dictionary: fromDictionary)
        
        mediaUid = dictionary["mediaUid"] as! String
        ref = DatabaseReference.media.ref().child(mediaUid).child("comments").child(uid)
    }
    
    func save(){
        ref.setValue(toDictionary())
    }
    
    func toDictionary() -> [String: Any]{
        
        return [
            "mediaUid":mediaUid,
            "uid":uid,
            "createdTime":createdTime,
            "from":from.toDictionary(),
            "caption":caption
        ]
    }
    
}

extension Comments:Equatable{}

func ==(lhs:Comments, rhs:Comments) -> Bool{
    return lhs.uid == rhs.uid
}
