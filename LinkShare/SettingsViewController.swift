//
//  SettingsViewController.swift
//  LinkShare
//
//  Created by Aaron on 11/15/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingsViewController: UIViewController {
    @IBAction func signOutPressed(_ sender: UIBarButtonItem) {
        do {
            try FIRAuth.auth()?.signOut()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.returnToAuth()
            }
        } catch {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Error while signing out, please try again.", comment: ""))
        }
    }
}
