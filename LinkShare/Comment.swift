//
//  Comment.swift
//  LinkShare
//
//  Created by Ju Hae Lee on 11/9/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Comment {
    var id: String
    var body: String
    var authorName: String
    var authorId: String
    var createdAt: Date
    
    init?(firebaseSnapshot: FIRDataSnapshot) {
        guard firebaseSnapshot.hasChild("authorName") && firebaseSnapshot.hasChild("authorId") && firebaseSnapshot.hasChild("body") && firebaseSnapshot.hasChild("createdAt") else { return nil }
        
        self.id = firebaseSnapshot.key
        self.body = firebaseSnapshot.childSnapshot(forPath: "body").value as! String
        self.authorName = firebaseSnapshot.childSnapshot(forPath: "authorName").value as! String
        self.authorId = firebaseSnapshot.childSnapshot(forPath: "authorId").value as! String
        self.createdAt = Date(timeIntervalSince1970: (firebaseSnapshot.childSnapshot(forPath: "createdAt").value as! NSString).doubleValue)
    }
    
    func toAnyObject() -> Any {
        return [
            "body": body,
            "authorName": authorName,
            "authorId": authorId,
            "createdAt": createdAt.timeIntervalSince1970.description
        ]
    }
}
