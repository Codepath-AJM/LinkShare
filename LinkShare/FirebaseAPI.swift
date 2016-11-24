//
//  FirebaseAPI.swift
//  LinkShare
//
//  Created by Aaron on 11/15/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAPI {
    static let sharedInstance: FirebaseAPI = FirebaseAPI()
    private let database: FIRDatabaseReference
    private let usersRef: FIRDatabaseReference
    private let linksRef: FIRDatabaseReference
    
    private let emptyObject: [String: Any] = [:]
    
    private init() {
        self.database = FIRDatabase.database().reference()
        self.usersRef = database.child("users")
        self.linksRef = database.child("links")
    }
    
    // We will have generated a User object with the response from Firebase Auth, but that is not queryable and manipulable in a way that we need, so duplicate user informatino we need into its own segment in the database
    func registerNewUser(user: User) {
        usersRef.child(user.id).setValue(["name": user.name, "email": user.email, "links": emptyObject, "bookmarks": emptyObject, "friends": emptyObject])
    }
    
    // Create a new entry for a shared link from a user with its information and provided users if any
    func createSharedLink(url: String, title: String?, users: [String]?) -> String? {
        guard let currentUser = User.currentUser else { return nil }
        
        let uniqueID = linksRef.childByAutoId().key
        var usersForFirebase: [String: Bool] = [currentUser.id: true]
        
        if let users = users {
            users.forEach {
                usersForFirebase[$0] = true
                usersRef.child($0).child("links").updateChildValues([$0: true])
            }
        }
        
        var value: [String: Any] = ["authorID": currentUser.id, "url": url, "users": usersForFirebase, "comments": emptyObject, "modifiedDate": Date().timeIntervalSince1970.description]
        
        if let title = title {
            value["title"] = title
        }
        
        linksRef.child(uniqueID).setValue(value)
        
        return uniqueID
    }
    
    // Removes the references to the user in the link and in the user object. Notably does not cull the link entirely if there are no further users after this removal.
    func leaveSharedLink(link: Link) {
        guard let currentUser = User.currentUser else { return }
        
        usersRef.child(currentUser.id).child("links").child(link.id).removeValue()
        linksRef.child(link.id).child("users").child(currentUser.id).removeValue()
    }
    
    // Store comments directly inside links because they are not referenceable outside the scope of links so they don't need to be stored that way.
    func createComment(onLink link: Link, body: String) {
        guard let currentUser = User.currentUser else { return }
        
        linksRef.child(link.id).child("comments").childByAutoId().setValue(["authorName": currentUser.name, "body": body, "createdAt": Date().timeIntervalSince1970.description])
        linksRef.child(link.id).child("modifiedDate").setValue(Date().timeIntervalSince1970.description)
    }
    
    // Get a list of hydrated Link objects for use in the UI
    func linksForCurrentUser() -> [Link] {
        guard let currentUser = User.currentUser else { return [] }
        
        var linkIDs: [String] = []
        var links: [Link] = []
        
        usersRef.child(currentUser.id).child("links").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            guard snapshot.childrenCount > 0 else { return }
            
            let enumerator = snapshot.children
            while let linkID = enumerator.nextObject() as? FIRDataSnapshot {
                linkIDs.append(linkID.key)
            }
        }
        
        linkIDs.forEach {
            let linkID = $0
            linksRef.queryOrdered(byChild: "createdAt").queryEqual(toValue: linkID).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                guard snapshot.childrenCount > 0 else { return }
                
                let enumerator = snapshot.children
                while let linkRaw = enumerator.nextObject() as? FIRDataSnapshot {
                    if let link = Link(firebaseSnapshot: linkRaw) {
                        links.append(link)
                    }
                }
            })
        }
        
        return links
    }
}
