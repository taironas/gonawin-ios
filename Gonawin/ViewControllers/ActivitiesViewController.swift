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
    
    let moreIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        tableView.tableFooterView = moreIndicator
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        refresh()
    }
    
    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        refresh(refreshControl)
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl?) {
        currentPage = 1
        
        self.provider?.getActivities(currentPage, count: 20)
            .catchError({ error in
                showError(self as! Error, from: error as! UIViewController)
                return Observable.empty()
            })
            .subscribe(onNext: {
                if $0.count > 0 {
                    self.activities.removeAll(keepingCapacity: true)
                    self.activities.insert($0, at: self.currentPage - 1)
                    self.tableView.reloadData()
                }
                
                sender?.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .addDisposableTo(self.disposeBag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(forIndexPath: indexPath)
    }
    
    fileprivate func configureCell(forIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell
        cell.activity = activities[indexPath.section][indexPath.row]
        
        return cell
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // scroll to bottom
        let currentOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - currentOffset
        let height = scrollView.frame.size.height
        
        if distanceFromBottom < height {
            moreIndicator.startAnimating()
            currentPage = currentPage + 1
            
            self.provider?.getActivities(currentPage, count: 20)
                .catchError({ error in
                    showError(self as! Error, from: error as! UIViewController)
                    self.moreIndicator.stopAnimating()
                    return Observable.empty()
                })
                .subscribe(onNext: {
                
                    self.moreIndicator.stopAnimating()
                    
                    if $0.count > 0 {
                        self.activities.insert($0, at: self.currentPage - 1)
                        self.tableView.reloadData()
                    }
                })
                .addDisposableTo(self.disposeBag)
        }
    }
}

