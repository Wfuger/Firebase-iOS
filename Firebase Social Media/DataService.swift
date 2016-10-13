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

class DataService {
    
    static let ds = DataService()
    
    private var _REF_VBASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REFF_BASE: FIRDatabaseReference {
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
