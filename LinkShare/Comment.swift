//
//  Comment.swift
//  LinkShare
//
//  Created by Ju Hae Lee on 11/9/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation

class Comment {
    var id: String
    var body: String
    var authorId: String
    var createdAt: Date
    
    init(dictionary: Dictionary<String, Any>) {
        // init - fake initializer
        id = dictionary["id"] as! String
        body = dictionary["body"] as! String
        authorId = dictionary["authorId"] as! String
        createdAt = dictionary["createdAt"] as! Date
    }
}
