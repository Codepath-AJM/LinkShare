//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Ju Hae Lee on 12/3/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Firebase

class ShareViewController: SLComposeServiceViewController, UserSelectViewControllerDelegate {
    
    private var urlString: String?
    private var friends = [User]()
    private var selectedFriend: User?
    
    override func viewDidLoad() {
        FIRApp.configure()
        
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        
        let propertyList = String(kUTTypePropertyList)

        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil) {
                (item, error) -> Void in
                guard let dictionary = item as? Dictionary<String, Any> else { return }
                OperationQueue.main.addOperation {
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? Dictionary<String, Any>, let urlString = results["URL"] as? String {
                        self.urlString = urlString
                    }
                }
            }
        } else {
            print("error")
        }
        
        FIRDatabase.database().reference().child("users").observeSingleEvent(of: .value) {
            (snapshot: FIRDataSnapshot) in
            
            var users: [User] = []
            guard snapshot.exists() && snapshot.hasChildren() else { return }
            
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
//                if (child.key != currentUser.id) {
                    if let user = User(firebaseSnapshot: child) {
                        users.append(user)
                    }
//                }
            }
            self.friends = users
        }
        
        selectedFriend = friends.first
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        // get user id
        guard let data = UserDefaults.init(suiteName: "group.com.linkshare")!.object(forKey: "current_user") as? Data else { return }
        
        let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        let userId = dictionary!["id"] as! String
        
        let linksRef = FIRDatabase.database().reference().child("links")
        let usersRef = FIRDatabase.database().reference().child("users")
        
        let uniqueID = linksRef.childByAutoId().key
        
        let value: [String: Any] = ["authorID": userId, "url": urlString!, "users": [selectedFriend!.id: true], "comments": [:], "modifiedDate": Date().timeIntervalSince1970.description, "title": self.contentText]
        
        linksRef.child(uniqueID).setValue(value)
        usersRef.child(userId).child("linkIDs").updateChildValues([uniqueID: false])
        
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        let item = SLComposeSheetConfigurationItem()!
        item.title = "Select User"
        item.value = selectedFriend?.name
        item.tapHandler = {
            // on tap
            let vc = UserSelectViewController()
            vc.friends = self.friends
            vc.delegate = self
            // vc.delegate = self
            self.pushConfigurationViewController(vc)
        }
        return [item]
    }
    
    func selected(friend: User) {
        selectedFriend = friend
        reloadConfigurationItems()
        popConfigurationViewController()
    }

}
