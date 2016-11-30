//
//  FeedTableViewController.swift
//  LinkShare
//
//  Created by Marisa Toodle on 11/15/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit
import SVProgressHUD

class FeedTableViewController: UITableViewController {
    
    var links = [Link]()
    var linkAuthors = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        FirebaseAPI.sharedInstance.linksForCurrentUser(completion: {
            linksArray in
            self.links = linksArray
            
            if self.links.count == 0 {
                SVProgressHUD.showInfo(withStatus: "Looks like you have don't have any links. Start sharing!")
            } else {
                for link in self.links {
                    FirebaseAPI.sharedInstance.userForID(userID: link.authorID, completion: {
                        user in
                        
                        if let name = user?.name {
                            self.linkAuthors.append(name)
                        }
                        
                        // if link is last link in array, then dismiss progress indicator and reload the table view
                        let linkIndex = self.links.index{$0 === link}
                        if linkIndex == self.links.endIndex - 1 {
                            SVProgressHUD.dismiss()
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        })

        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! CardCell
        
        cell.titleLabel.text = self.links[indexPath.row].title
        cell.detailsLabel.text = "Shared by \(linkAuthors[indexPath.row])"
        
        let comments = self.links[indexPath.row].comments
        cell.commentsLabel.text = String(comments.count)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
