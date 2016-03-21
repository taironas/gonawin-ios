//
//  RankingViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 21/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class RankingViewController: UITableViewController {
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
        tableView.registerNib(UINib(nibName: "UserRankingTableViewCell", bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.Ranking.rawValue)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.Ranking.rawValue, forIndexPath: indexPath) as! UserRankingTableViewCell
        cell.user = users[indexPath.row]
        cell.rankinglabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
}