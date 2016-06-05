//
//  DataService.swift
//  Pop
//
//  Created by Justin Mac on 6/5/16.
//  Copyright © 2016 Justin Mac. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://pop-34207.firebaseio.com/"

class PopDatabase {
    static let dataService = PopDatabase()
    private var database = FIRDatabase.database().reference()
    private var user = FIRDatabase.database().referenceFromURL("\(BASE_URL)/users")
    private var message = FIRDatabase.database().referenceFromURL("\(BASE_URL)/messages")
    
    var getDatabase : FIRDatabaseReference {
        return database
    }
    
    var getUser : FIRDatabaseReference {
        return user
    }
    
    var getCurrentUser : FIRDatabaseReference {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let currentUser = FIRDatabase.database().reference().childByAppendingPath("users").childByAppendingPath(userID)
        return currentUser
    }
    
    var getMessage : FIRDatabaseReference {
        return message
    }
    
    func createNewAccount(uid: String, user: Dictionary<String, String>) {
        self.user.child(uid).setValue(user)
    }
    
}