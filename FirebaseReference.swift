//
//  FirebaseReferencia.swift
//  Momentos
//
//  Created by Bruno Corrêa on 24/04/17.
//  Copyright © 2017 Br4Dev. All rights reserved.
//

import Foundation
import Firebase

enum DatabaseReference {
    
    case root
    case user(uid: String)
    case media
    case chats
    case messages
    
    func ref() -> FIRDatabaseReference {
        return rootRef.child(path)
    }
    
    private var rootRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
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

enum StorageReference {
    
    case root
    case images
    case profileImages
    
    func ref() -> FIRStorageReference {
        return baseRef.child(path)
    }
    
    private var baseRef:FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    private var path:String {
        
        switch self {
        case .root:
            return ""
        case .images:
            return "images"
        case .profileImages:
            return "profileImages"
            
        }
    }

}


