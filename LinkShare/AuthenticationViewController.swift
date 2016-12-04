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
import FirebaseAuth

class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var displayNameTextField: UITextField!
    @IBOutlet weak var authActionButton: UIButton!

    @IBOutlet weak var emailLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var displayNameLabelTopConstraint: NSLayoutConstraint!

    public var authType: AuthenticationType!
    
    private var displayName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
        
        if authType == .login {
            displayNameLabel.isHidden = true
            displayNameTextField.isHidden = true
            authActionButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        } else if authType == .signup {
            displayNameLabel.isHidden = false
            displayNameTextField.isHidden = false
            authActionButton.setTitle(NSLocalizedString("Sign Up", comment: ""), for: .normal)
        }
    }
    
    @IBAction func cancelAuthentication(_ sender: UIButton) {
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func authActionButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Please provide a username.", comment: ""))
            return
        }
        
        guard let password = passwordTextField.text else {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Please provide a password.", comment: ""))
            return
        }
        
        if authType == .signup {
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
            self?.view.endEditing(true)
            
            if let user = user, let email = user.email {
                let userReady = { (user: User?) in
                    guard let user = user else {
                        SVProgressHUD.showError(withStatus: NSLocalizedString("Unexpected error, could not find user.", comment: ""))
                        return
                    }
                    
                    User.currentUser = user
                    
                    // Demo code, create a new shared link shared to nobody but the implicit share to current user, then put a comment on it with every login/registration for now.
                    
                    let randomNumber = arc4random_uniform(UINT32_MAX)
                    let linkID = FirebaseAPI.sharedInstance.createSharedLink(url: "http://www.google.co.uk", title: "Google UK \(randomNumber)", users: nil)
                    
                    if let linkID = linkID {
                        FirebaseAPI.sharedInstance.linkForID(linkID: linkID, completion: { (link: Link?) in
                            if let link = link {
                                FirebaseAPI.sharedInstance.createComment(onLink: link, body: "Google UK! \(randomNumber)")
                            }
                        })
                    }
                    
                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.authenticationComplete()
                    }
                }
                
                if let displayName = self?.displayName {
                    let authedUser = User(id: user.uid, email: email, name: displayName, imageURL: user.photoURL)
                    FirebaseAPI.sharedInstance.registerNewUser(user: authedUser)
                    userReady(authedUser)
                } else {
                    FirebaseAPI.sharedInstance.userForID(userID: user.uid, completion: { (user: User?) in
                        userReady(user)
                    })
                }
            }
        }
        
        SVProgressHUD.show()
        
        if authType == .login {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: authComplete)
        } else {
            displayName = displayNameTextField.text
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: authComplete)
        }
    }
    
    public enum AuthenticationType {
        case login
        case signup
    }
    
    // - MARK: Text Field Delegate Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // handle text entered in field
        if textField.text == "" {
            if textField === emailTextField {
                label(emailLabel, withConstraint: emailLabelTopConstraint, isDisplayed: true)
            } else if textField === passwordTextField {
                label(passwordLabel, withConstraint: passwordLabelTopConstraint, isDisplayed: true)
            } else if textField === displayNameTextField {
                label(displayNameLabel, withConstraint: displayNameLabelTopConstraint, isDisplayed: true)
            }
        }
        
        if textField.text?.characters.count == 1 && string == "" {
            if textField === emailTextField {
                label(emailLabel, withConstraint: emailLabelTopConstraint, isDisplayed: false)
            } else if textField === passwordTextField {
                label(passwordLabel, withConstraint: passwordLabelTopConstraint, isDisplayed: false)
            } else if textField === displayNameTextField {
                label(displayNameLabel, withConstraint: displayNameLabelTopConstraint, isDisplayed: false)
            }
        }
        
        return true
    }
    
    // - MARK: Helper Methods
    func configureTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        displayNameTextField.delegate = self
        
        emailTextField.becomeFirstResponder()
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"Email address", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSForegroundColorAttributeName: UIColor.gray])
        
        displayNameTextField.attributedPlaceholder = NSAttributedString(string:"Display name", attributes: [NSForegroundColorAttributeName: UIColor.gray])
    }
    
    func label(_ label: UILabel, withConstraint constraint: NSLayoutConstraint, isDisplayed: Bool) {
        if isDisplayed {
            UIView.animate(withDuration: 0.5, animations: {
                label.textColor = UIColor.gray.withAlphaComponent(1.0)
                label.center.y -= 31
                constraint.constant -= 31
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                label.center.y += 31
                constraint.constant += 31
            })
        }
    }
}
