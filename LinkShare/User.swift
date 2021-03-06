//
//  User.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/10/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class User: NSObject {
    var dictionary: [String: Any] = [:] // for auth convenience
    var id: String
    var email: String
    var name: String
    var imageURL: URL? // Right now this isn't going to ever be set because we're using simple auth and it's only ever going to come from a third party unless we build our own mechanism to set it (not currently sending nil to Firebase either so it's just absent)
//    var linkIDs: [String] = []
//    var friendIDs: [String] = []
//    var bookmarkIDs: [String] = [] // Not currently supported in the code I wrote for Firebase
    
    static var currentUser: User?
    
    func setDictionary() {
        self.dictionary = ["id": self.id, "email": self.email, "name": self.name, "imageURL": "\(self.imageURL)"]
    }
    
    init?(firebaseSnapshot: FIRDataSnapshot) {
        guard firebaseSnapshot.exists() && firebaseSnapshot.hasChild("email") && firebaseSnapshot.hasChild("name") else { return nil }
        
        self.id = firebaseSnapshot.key
        self.email = firebaseSnapshot.childSnapshot(forPath: "email").value as! String
        self.name = firebaseSnapshot.childSnapshot(forPath: "name").value as! String
        self.dictionary = ["id": self.id, "email": self.email, "name": self.name, "imageURL": "\(self.imageURL)"]
        
//        let linksSnapshot = firebaseSnapshot.childSnapshot(forPath: "linkIDs")
//        if linksSnapshot.exists() && linksSnapshot.hasChildren() {
//            let enumerator = linksSnapshot.children
//            while let linksRaw = enumerator.nextObject() as? FIRDataSnapshot {
//                linkIDs.append(linksRaw.key)
//            }
//        }
//        
//        let friendsSnapshot = firebaseSnapshot.childSnapshot(forPath: "friendIDs")
//        if friendsSnapshot.exists() && friendsSnapshot.hasChildren() {
//            let enumerator = friendsSnapshot.children
//            while let friendsRaw = enumerator.nextObject() as? FIRDataSnapshot {
//                friendIDs.append(friendsRaw.key)
//            }
//        }
    }
    
    init(id: String, email: String, name: String, imageURL: URL? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.dictionary = ["id": self.id, "email": self.email, "name": self.name, "imageURL": "\(self.imageURL)"]
        
//        if let linkIDs = linkIDs {
//            self.linkIDs = linkIDs
//        }
//        if let friendIDs = friendIDs {
//            self.friendIDs = friendIDs
//        }
//        if let bookmarkIDs = bookmarkIDs {
//            self.bookmarkIDs = bookmarkIDs
//        }
    }
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        self.id = dictionary["id"] as! String
        self.email = dictionary["email"] as! String
        self.name = dictionary["name"] as! String
        if let imageURL = dictionary["imageURL"] as? String {
            self.imageURL = URL(string: imageURL)
        }
    }
}
