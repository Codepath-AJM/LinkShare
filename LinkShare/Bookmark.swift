//
//  Bookmark.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/10/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation

class Bookmark {
    var shareableID: String
    var userID: String
    
    init(dictionary: [String: Any]) {
        // TODO: Update initializer
        shareableID = dictionary["shareableID"] as! String
        userID = dictionary["userID"] as! String
    }
}
