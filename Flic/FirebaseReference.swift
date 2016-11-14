//
//  FirebaseReference.swift
//  Flic
//
//  Created by Sahit Penmatcha on 11/10/16.
//  Copyright © 2016 Sahit Penmatcha. All rights reserved.
//
//  Create 2 Enums to generate references to Firebase database

import Foundation
import Firebase

enum DatabaseReference
{
    case root
    case users(uid: String)
    case media                // posts (photo, video, text)
    case chats
    case messages
    
    // MARK: - Public
    
    func reference() -> FIRDatabaseReference {
        return rootRef.child(path)
    }
    
    private var rootRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .users(let uid):
            return "users/\(uid)"
        case .media:
            return "media"
        case  .chats:
            return "chats"
        case .messages:
            return "messages"
        }
    }
}

enum StorageReference
{
    case root
    case images         // for post
    case profileImages  // for user
    
    func reference() -> FIRStorageReference {
        return baseRef.child(path)
    }
    
    private var baseRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    private var path: String {
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
