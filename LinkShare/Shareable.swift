//
//  ShareableProtocol.swift
//  LinkShare
//
//  Created by Ju Hae Lee on 11/9/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation

protocol Shareable {
    var id: String { get set }
    var authorID: String { get set }
    var comments: [Comment] { get set }
    var users: [User] { get set }
    var modifiedDate: Date { get set }
    var lastReadDate: TimeInterval? { get set }
    
    func toAnyObject() -> Any
}
