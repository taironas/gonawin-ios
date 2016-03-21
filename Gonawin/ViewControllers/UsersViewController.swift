//
//  UsersViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 20/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class UsersViewController: UITableViewController {
    var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "UserTableViewCell", bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.User.rawValue)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.User.rawValue, forIndexPath: indexPath) as! UserTableViewCell
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("showUser", sender: self)
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showUser"{
//            if let vc = segue.destinationViewController as? UserViewController {
//                if let userIndex = tableView.indexPathForSelectedRow?.row {
//                    vc.userID = users[userIndex].id
//                }
//            }
//        }
//    }
    
}
