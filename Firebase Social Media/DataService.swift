//
//  DataService.swift
//  Firebase Social Media
//
//  Created by Will Fuger on 10/13/16.
//  Copyright © 2016 BoogieSquad. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    // DB references
    private var _REF_VBASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage references
    private var _REF_POST_PICS = STORAGE_BASE.child("post-pics")
    
    
    var REF_POST_PICS: FIRStorageReference {
        return _REF_POST_PICS
    }
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_VBASE
    }
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirbaseDBUser(uid: String, userData: [String:String]) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
