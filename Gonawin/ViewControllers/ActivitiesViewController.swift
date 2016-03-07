//
//  ActivitiesViewController
//  Gonawin
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine
import RxSwift

class ActivitiesViewController: UITableViewController {
    var activities = [[Activity]]()
    var currentPage = 1
    
    private let disposeBag = DisposeBag()
    private var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
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
        self.provider?.getActivities(currentPage, count: 20)
            .debug()
            .catchError({ error in
                showError(self, error: error)
                return Observable.empty()
            })
            .subscribeNext {
                if $0.count > 0 {
                    self.activities.removeAll(keepCapacity: true)
                    self.activities.insert($0, atIndex: self.currentPage - 1)
                    self.tableView.reloadData()
                }
                
                sender?.endRefreshing()
            }
            .addDisposableTo(self.disposeBag)
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
            
            self.provider?.getActivities(currentPage, count: 20)
                .debug()
                .catchError({ error in
                    showError(self, error: error)
                    return Observable.empty()
                })
                .subscribeNext {
                
                    if $0.count > 0 {
                        self.activities.insert($0, atIndex: self.currentPage - 1)
                        self.tableView.reloadData()
                    }
                }
                .addDisposableTo(self.disposeBag)
        }
    }
}

