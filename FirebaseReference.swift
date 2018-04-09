//
//  FirebaseReferencia.swift
//  Momentos
//
//  Created by Bruno Corrêa on 24/04/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import Foundation
import Firebase

enum DatabaseRef {
    
    case root
    case user(uid: String)
    case media
    case chats
    case messages
    
    func ref() -> DatabaseReference {
        return rootRef.child(path)
    }
    
    private var rootRef: DatabaseReference {
        return Database.database().reference()
    }
    
    private var path:String {
        
        switch self {
        case .root:
            return ""
        case .user(let uid):
            return "users/\(uid)"
        case .messages:
            return "messages"
        case .media:
            return "media"
        case .chats:
            return "chats"
    
        }
    }
}

enum StorageRef {
    
    case root
    case images
    case profileImages
    case chatImages
    
    func ref() -> StorageReference {
        return baseRef.child(path)
    }
    
    private var baseRef:StorageReference {
        return Storage.storage().reference()
    }
    
    private var path:String {
        
        switch self {
        case .root:
            return ""
        case .images:
            return "images"
        case .profileImages:
            return "profileImages"
        case .chatImages:
            return "chatImages"
            
        }
    }

}


