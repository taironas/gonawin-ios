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
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var provider: AuthorizedGonawinEngine?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        currentPage = 1
        
        self.provider?.getTeams(currentPage, count: 20)
            .debug()
            .catchError({ error in
                showError(self as! Error, from: error as! UIViewController)
                return Observable.empty()
            })
            .subscribe(onNext: {
                if $0.count > 0 {
                    self.teams.removeAll(keepingCapacity: true)
                    self.teams.insert(contentsOf: $0, at: self.currentPage - 1)
                    self.tableView?.reloadData()
                }
            })
            .addDisposableTo(self.disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "TeamTableViewCell", bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.Team.rawValue)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.Team.rawValue, for: indexPath) as! TeamTableViewCell
        cell.team = teams[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTeam", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTeam"{
            if let vc = segue.destination as? TeamViewController {
                if let teamIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                    vc.teamID = teams[teamIndex].id
                }
            }
        }
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // scroll to bottom
        let currentOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - currentOffset
        let height = scrollView.frame.size.height
        if distanceFromBottom < height {
            currentPage = currentPage + 1
            
            self.provider?.getTeams(currentPage, count: 20)
                .debug()
                .catchError({ error in
                    showError(self as! Error, from: error as! UIViewController)
                    return Observable.empty()
                })
                .subscribe(onNext: {
                    if $0.count > 0 {
                        self.teams.append(contentsOf: $0)
                        self.tableView?.reloadData()
                    }
                })
                .addDisposableTo(self.disposeBag)
        }
    }
}
