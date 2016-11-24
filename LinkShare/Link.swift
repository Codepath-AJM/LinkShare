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
    var comments: [Comment]
    var users: [User]
    var modifiedDate: Date
    var lastReadDate: TimeInterval?
    var title: String?
    var url: URL
    
    init?(firebaseSnapshot: FIRDataSnapshot) {
        guard firebaseSnapshot.hasChild("authorID") && firebaseSnapshot.hasChild("url") && firebaseSnapshot.hasChild("users") else { return nil }
        
        guard let urlString = firebaseSnapshot.childSnapshot(forPath: "url").value as? String, let url = URL(string: urlString) else { return nil }
        
        self.id = firebaseSnapshot.key
        self.authorID = firebaseSnapshot.childSnapshot(forPath: "authorID").value as! String
        self.url = url
        self.title = firebaseSnapshot.childSnapshot(forPath: "title").value as? String
        
        let commentsSnapshot = firebaseSnapshot.childSnapshot(forPath: "comments")
        if commentsSnapshot.childrenCount > 0 {
            var commentsList: [Comment] = []
            let enumerator = commentsSnapshot.children
            while let commentRaw = enumerator.nextObject() as? FIRDataSnapshot {
                if let comment = Comment(firebaseSnapshot: commentRaw) {
                    commentsList.append(comment)
                }
            }
            self.comments = commentsList
        }
        
        let usersSnapshot = firebaseSnapshot.childSnapshot(forPath: "users")
        if usersSnapshot.childrenCount > 0 {
            var usersList: [User] = []
            let enumerator = usersSnapshot.children
            while let userRaw = enumerator.nextObject() as? FIRDataSnapshot {
                if let user = User(firebaseSnapshot: userRaw) {
                    usersList.append(user)
                }
            }
            self.users = usersList
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
