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
    var body: String
    var authorName: String
    var createdAt: Date
    
    init?(firebaseSnapshot: FIRDataSnapshot) {
        guard firebaseSnapshot.hasChild("authorName") && firebaseSnapshot.hasChild("body") && firebaseSnapshot.hasChild("createdAt") else { return nil }
        
        self.body = firebaseSnapshot.childSnapshot(forPath: "body").value as! String
        self.authorName = firebaseSnapshot.childSnapshot(forPath: "authorName").value as! String
        self.createdAt = Date(timeIntervalSince1970: (firebaseSnapshot.childSnapshot(forPath: "createdAt").value as! NSString).doubleValue)
    }
    
    func toAnyObject() -> Any {
        return [
            "body": body,
            "authorName": authorName,
            "createdAt": createdAt.timeIntervalSince1970.description
        ]
    }
}
