//
//  User.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/10/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {
    var id: String
    var email: String
    var name: String?
    var imageURL: URL?
    
    static var currentUser: User?
    
    init?(firebaseSnapshot: FIRDataSnapshot) {
        
    }
    
    init(id: String, email: String, name: String?, imageURL: URL?) {
        self.id = id
        self.email = email
        self.name = name
        self.imageURL = imageURL
    }
}
