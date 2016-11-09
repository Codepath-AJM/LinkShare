//
//  Link.swift
//  LinkShare
//
//  Created by Ju Hae Lee on 11/9/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation

class Link: Shareable {
    var id: String
    var authorID: String
    var comments: [Comment]?
    var userIDs: [String]
    var modifiedDate: Date
    var lastReadDate: Dictionary<String, Date>?
    var title: String?
    var url: URL
    
    init(dictionary: Dictionary<String, Any>) {
        // init - fake initializer
        id = dictionary["id"] as! String
        authorID = dictionary["authorID"] as! String
        comments = dictionary["comments"] as? [Comment]
        userIDs = dictionary["userIDs"] as! [String]
        modifiedDate = dictionary["modifiedDate"] as! Date
        lastReadDate = dictionary["lastReadDate"] as? Dictionary<String, Date>
        title = dictionary["title"] as? String
        url = dictionary["url"] as! URL
    }
}
