//
//  TeamsViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine
import RxSwift

class TeamsViewController: UITableViewController {
    var teams = [Team]()
    var currentPage = 1
    
    private let disposeBag = DisposeBag()
    private var provider: AuthorizedGonawinEngine?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        currentPage = 1
        
        self.provider?.getTeams(currentPage, count: 20)
            .debug()
            .catchError({ error in
                showError(self, error: error)
                return Observable.empty()
            })
            .subscribeNext {
                if $0.count > 0 {
                    self.teams.removeAll(keepCapacity: true)
                    self.teams.insertContentsOf($0, at: self.currentPage - 1)
                    self.tableView?.reloadData()
                }
            }
            .addDisposableTo(self.disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "TeamTableViewCell", bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.Team.rawValue)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.Team.rawValue, forIndexPath: indexPath) as! TeamTableViewCell
        cell.team = teams[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showTeam", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTeam"{
            if let vc = segue.destinationViewController as? TeamViewController {
                if let teamIndex = tableView.indexPathForSelectedRow?.row {
                    vc.teamID = teams[teamIndex].id
                }
            }
        }
    }
    
    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        // scroll to bottom
        let currentOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - currentOffset
        let height = scrollView.frame.size.height
        if distanceFromBottom < height {
            currentPage = currentPage + 1
            
            self.provider?.getTeams(currentPage, count: 20)
                .debug()
                .catchError({ error in
                    showError(self, error: error)
                    return Observable.empty()
                })
                .subscribeNext {
                    if $0.count > 0 {
                        self.teams.appendContentsOf($0)
                        self.tableView?.reloadData()
                    }
                }
                .addDisposableTo(self.disposeBag)
        }
    }
}
