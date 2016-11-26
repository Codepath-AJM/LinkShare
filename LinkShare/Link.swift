//
//  Link.swift
//  LinkShare
//
//  Created by Ju Hae Lee on 11/9/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation
import Firebase

class Link: Shareable {
    var id: String
    var authorID: String
    var comments: [Comment] = []
    var users: [User] = []
    var modifiedDate: Date
    var lastReadDate: TimeInterval?
    var title: String?
    var url: URL
    
    init?(firebaseSnapshot: FIRDataSnapshot) {
        guard firebaseSnapshot.hasChild("authorID") && firebaseSnapshot.hasChild("url") && firebaseSnapshot.hasChild("users") && firebaseSnapshot.hasChild("modifiedDate") else { return nil }
        
        guard let urlString = firebaseSnapshot.childSnapshot(forPath: "url").value as? String, let derivedURL = URL(string: urlString) else { return nil }
        
        id = firebaseSnapshot.key
        authorID = firebaseSnapshot.childSnapshot(forPath: "authorID").value as! String
        url = derivedURL
        title = firebaseSnapshot.childSnapshot(forPath: "title").value as? String
        modifiedDate = Date(timeIntervalSince1970: (firebaseSnapshot.childSnapshot(forPath: "modifiedDate").value as! NSString).doubleValue)
        
        let commentsSnapshot = firebaseSnapshot.childSnapshot(forPath: "comments")
        if commentsSnapshot.exists() && commentsSnapshot.hasChildren() {
            let enumerator = commentsSnapshot.children
            while let commentRaw = enumerator.nextObject() as? FIRDataSnapshot {
                if let comment = Comment(firebaseSnapshot: commentRaw) {
                    comments.append(comment)
                }
            }
        }
        
        let usersSnapshot = firebaseSnapshot.childSnapshot(forPath: "users")
        if usersSnapshot.exists() && usersSnapshot.hasChildren() {
            let enumerator = usersSnapshot.children
            while let userRaw = enumerator.nextObject() as? FIRDataSnapshot {
                if let user = User(firebaseSnapshot: userRaw) {
                    users.append(user)
                }
            }
        }
        
        let defaultsLastReadDate = UserDefaults.standard.double(forKey: "lastReadDate-\(firebaseSnapshot.key)")
        if defaultsLastReadDate > 0 {
            self.lastReadDate = defaultsLastReadDate
        }
    }
    
    init(id: String, authorID: String, comments: [Comment], users: [User], modifiedDate: Date, lastReadDate: TimeInterval?, title: String?, url: URL) {
        self.id = id
        self.authorID = authorID
        self.comments = comments
        self.users = users
        self.modifiedDate = modifiedDate
        self.lastReadDate = lastReadDate
        self.title = title
        self.url = url
    }
    
    func updateLastReadDate() {
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "lastReadDate-\(id)")
        UserDefaults.standard.synchronize()
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "authorID": authorID,
            "modifiedDate": modifiedDate.timeIntervalSince1970.description,
            "title": title!,
            "url": url.absoluteString
        ]
    }
}
