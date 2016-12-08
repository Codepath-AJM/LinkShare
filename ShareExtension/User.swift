//
//  User.swift
//  LinkShare
//
//  Created by Ju Hae Lee on 12/7/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation
import Firebase

class User {
    var id: String
    var name: String
    var imageURL: URL?
    
    init(id: String, name: String, imageURL: URL? = nil) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as! String
        self.name = dictionary["name"] as! String
        if let imageURL = dictionary["imageURL"] as? String {
            self.imageURL = URL(string: imageURL)
        }
    }
    
    init?(firebaseSnapshot: FIRDataSnapshot) {
        guard firebaseSnapshot.exists() && firebaseSnapshot.hasChild("email") && firebaseSnapshot.hasChild("name") else { return nil }
        
        self.id = firebaseSnapshot.key
        self.name = firebaseSnapshot.childSnapshot(forPath: "name").value as! String

    }
}
