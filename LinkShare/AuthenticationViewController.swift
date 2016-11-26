//
//  AuthenticationViewController.swift
//  LinkShare
//
//  Created by Aaron on 11/15/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AuthenticationViewController: UIViewController {
    @IBOutlet var authTypeSegmentedControl: UISegmentedControl!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var displayNameTextField: UITextField!
    @IBOutlet var authActionButton: UIBarButtonItem!
    
    private var displayName: String?
    
    @IBAction func authModeToggled(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            displayNameLabel.isHidden = true
            displayNameTextField.isHidden = true
            authActionButton.title = NSLocalizedString("Sign In", comment: "")
        } else {
            displayNameLabel.isHidden = false
            displayNameTextField.isHidden = false
            authActionButton.title = NSLocalizedString("Sign Up", comment: "")
        }
    }
    
    @IBAction func authActionButtonPressed(_ sender: UIBarButtonItem) {
        guard let email = emailTextField.text else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Please provide a username.", comment: ""))
            return
        }
        
        guard let password = passwordTextField.text else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Please provide a password.", comment: ""))
            return
        }
        
        if authTypeSegmentedControl.selectedSegmentIndex == 1 {
            guard displayNameTextField.text != nil else {
                SVProgressHUD.showError(withStatus: NSLocalizedString("Please provide a display name.", comment: ""))
                return
            }
        }
        
        let authComplete: FIRAuthResultCallback = { [weak self] (user: FIRUser?, error: Error?) in
            if let error = error {
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                return
            }
            
            SVProgressHUD.dismiss()
            
            if let user = user, let email = user.email {
                var newUser: User!
                if let displayName = self?.displayName {
                    newUser = User(id: user.uid, email: email, name: displayName, imageURL: user.photoURL)
                } else {
                    newUser = User(id: user.uid, email: email, name: user.displayName ?? "No name", imageURL: user.photoURL)
                }
                
                FirebaseAPI.sharedInstance.registerNewUser(user: newUser)
                User.currentUser = newUser
                
                // Demo code, create a new shared link shared to nobody but the implicit share to current user, then put a comment on it.
                let linkID = FirebaseAPI.sharedInstance.createSharedLink(url: "http://www.google.co.uk", title: "Google UK", users: nil)
                
                if let linkID = linkID {
                    FirebaseAPI.sharedInstance.linkForID(linkID: linkID, completion: { (link: Link?) in
                        if let link = link {
                            FirebaseAPI.sharedInstance.createComment(onLink: link, body: "Google UK!")
                        }
                    })
                }
            }
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.authenticationComplete()
            }
        }
        
        SVProgressHUD.show()
        
        if authTypeSegmentedControl.selectedSegmentIndex == 0 {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: authComplete)
        } else {
            displayName = displayNameTextField.text
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: authComplete)
        }
    }
}
