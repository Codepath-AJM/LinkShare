//
//  Friend.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/10/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation

class Friend {
    var fromUser: String
    var toUser: String
    var status: FriendshipStatus
    
    init (dictionary: [String: Any]) {
        // TODO: Update initializer
        fromUser = dictionary["fromUser"] as! String
        toUser = dictionary["toUser"] as! String
        status = dictionary["status"] as! FriendshipStatus
    }
}
