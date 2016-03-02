//
//  ActivitiesViewController
//  Gonawin
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class ActivitiesViewController: UITableViewController {
    var activities = [[Activity]]()
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        currentPage = 1
        refresh()
    }
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        // TODO: call activities endpoint of the GonawinEngine
        /*GonawinAPI.client.activites(currentPage, count: 20) {
            newActivities, error in
            
            if newActivities.count > 0 {
                self.activities.removeAll(keepCapacity: true)
                self.activities.insert(newActivities, atIndex: self.currentPage - 1)
                self.tableView.reloadData()
            }
            
            if error != nil {
                showError(self, error: error!)
            }
            
            sender?.endRefreshing()
        }*/
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return activities.count
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return configureCell(forIndexPath: indexPath)
    }
    
    private func configureCell(forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! ActivityTableViewCell
        cell.activity = activities[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        // scroll to bottom
        let currentOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - currentOffset
        let height = scrollView.frame.size.height
        if distanceFromBottom < height {
            currentPage = currentPage + 1
            
            // TODO: call activities endpoint of the GonawinEngine
            /*GonawinAPI.client.activites(currentPage, count: 20) {
                newActivities, error in
                
                if newActivities.count > 0 {
                    self.activities.insert(newActivities, atIndex: self.currentPage - 1)
                    self.tableView.reloadData()
                }
                
                if error != nil {
                    showError(self, error: error!)
                }
            }*/
        }
    }
}

