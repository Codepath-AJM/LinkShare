//
//  SettingsViewController.swift
//  LinkShare
//
//  Created by Aaron on 11/15/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

enum SettingsRowIdentifier : String {
    case Friends = "Friends"
    case SignOut = "Sign Out"
}

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableStruct: [[SettingsRowIdentifier]] = [[.Friends], [.SignOut]]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // remove empty cells at the end of tableView
        tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableStruct.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableStruct[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell") as! SettingsCell
        let settingsIdentifier = tableStruct[indexPath.section][indexPath.row]
        print("settingsIdent \(settingsIdentifier.rawValue)")
        cell.settingsIdentifier = settingsIdentifier
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        // do things depending on what cell is clicked
        let selectedCell = tableView.cellForRow(at: indexPath) as! SettingsCell
        let settingsIdentifier = selectedCell.settingsIdentifier!
        switch settingsIdentifier {
        case .Friends:
            print("segue to friends!")
            break
        case .SignOut:
            signOutPressed()
            break
        }
    }
    
    func signOutPressed() {
        do {
            try FIRAuth.auth()?.signOut()
            // remove user from defaults
            UserDefaults.standard.set(nil, forKey: "current_user")
            
            // transition back to auth page
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.returnToAuth()
            }
        } catch {
            SVProgressHUD.showError(withStatus: NSLocalizedString("Error while signing out, please try again.", comment: ""))
        }
    }
}
