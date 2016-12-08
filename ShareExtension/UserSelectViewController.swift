//
//  UserSelectViewController.swift
//  LinkShare
//
//  Created by Ju Hae Lee on 12/7/16.
//  Copyright © 2016 codepath-ajm. All rights reserved.
//

import UIKit

protocol UserSelectViewControllerDelegate: class {
    func selected(friend: User)
}

class UserSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: UserSelectViewControllerDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var friends = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Select User"
        
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell
        if cell == nil {
            tableView.register(UINib.init(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "userCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? UserCell else { return }
        cell.user = friends[indexPath.row]
        cell.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selected(friend: friends[indexPath.row])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
