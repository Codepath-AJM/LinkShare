//
//  User.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/10/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation

class User: NSObject {
    var id: String
    var email: String
    var name: String?
    var imageURL: URL?
    
    static var currentUser: User?
    
    init(dictionary: [String: Any]) {
        // TODO: Update initializer
        id = dictionary["id"] as! String
        email = dictionary["email"] as! String
        name = dictionary["name"] as? String
        imageURL = dictionary["imageURL"] as? URL
    }
    
    init(id: String, email: String, name: String?, imageURL: URL?) {
        self.id = id
        self.email = email
        self.name = name
        self.imageURL = imageURL
    }
}
