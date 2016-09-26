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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "UserRankingTableViewCell", bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.ranking.rawValue)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.ranking.rawValue, for: indexPath as IndexPath) as! UserRankingTableViewCell
        cell.user = users[indexPath.row]
        cell.rankinglabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
}
