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
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    let authComplete: FIRAuthResultCallback = { (user: FIRUser?, error: Error?) in
        if let error = error {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            return
        }
        
        SVProgressHUD.dismiss()
        
        if let user = user, let email = user.email {
            User.currentUser = User(id: user.uid, email: email, name: user.displayName, imageURL: user.photoURL)
            
            let randomNumber = arc4random_uniform(UINT32_MAX)
            let shareable: Shareable = Link(id: "asdf\(randomNumber)", authorID: user.uid, comments: nil, userIDs: [user.uid], modifiedDate: Date(), lastReadDate: nil, title: "A title_\(randomNumber)", url: URL(string: "http://www.google.com")!)
            FIRDatabase.database().reference().child("shareables").child("asdf\(randomNumber)").setValue(shareable.toAnyObject())
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.authenticationComplete()
        }
        
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        SVProgressHUD.show()
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: authComplete)
    }
    @IBAction func signInPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        SVProgressHUD.show()
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: authComplete)
    }
}
