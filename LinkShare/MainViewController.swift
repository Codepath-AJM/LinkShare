//
//  MainViewController.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/8/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        signupButton.layer.cornerRadius = 5
    }
    
    @IBAction func goToAuthentication(sender: UIButton) {
        performSegue(withIdentifier: "showAuthentication", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UIButton {
            let authVC = segue.destination as! AuthenticationViewController
            if sender === loginButton {
                authVC.authType = .login
            } else {
                authVC.authType = .signup
            }
        }
    }
}

