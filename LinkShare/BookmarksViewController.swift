//
//  BookmarksViewController.swift
//  LinkShare
//
//  Created by Marisa Toodle on 12/6/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class BookmarksViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var links = [(link: Link, bookmarked: Bool)]()
    var linkAuthors = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        
        tableView.register(UINib(nibName: "LinkCell", bundle: nil), forCellReuseIdentifier: "LinkCell")
        tableView.estimatedRowHeight = 134
        tableView.rowHeight = UITableViewAutomaticDimension
        
        FirebaseAPI.sharedInstance.linksForCurrentUser(onlyBookmarks: true, completion: {
            linksArray in
            self.links = linksArray
            
            if self.links.count == 0 {
                SVProgressHUD.showInfo(withStatus: "Looks like you have don't have any links. Start sharing!")
            } else {
                for linkTuple in self.links {
                    FirebaseAPI.sharedInstance.userForID(userID: linkTuple.link.authorID, completion: {
                        user in
                        
                        if let name = user?.name {
                            self.linkAuthors.append(name)
                        }
                        
                        // if link is last link in array, then dismiss progress indicator and reload the table view
                        let linkIndex = self.links.index{$0 == linkTuple}
                        if linkIndex == self.links.endIndex - 1 {
                            SVProgressHUD.dismiss()
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath) as! LinkCell
        let link = links[indexPath.row]
        cell.link = link
        cell.detailsLabel.text = "Shared by \(linkAuthors[indexPath.row])"
        
        return cell
    }
}
