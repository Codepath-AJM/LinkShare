//
//  User.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/10/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation

class User {
    var id: String
    var email: String
    var name: String?
    var imageURL: URL?
    
    init(dictionary: [String: Any]) {
        // TODO: Update initializer
        id = dictionary["id"] as! String
        email = dictionary["email"] as! String
        name = dictionary["name"] as? String
        imageURL = dictionary["imageURL"] as? URL
    }
}
