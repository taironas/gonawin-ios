//
//  TournamentsViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine
import RxSwift

class TournamentsViewController: UITableViewController {
                            
    var tournaments = [Tournament]()
    var currentPage = 1
    
    private let disposeBag = DisposeBag()
    private var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        currentPage = 1
        
        self.provider?.getTournaments(currentPage, count: 20)
            .debug()
            .catchError({ error in
                showError(self, error: error)
                return Observable.empty()
            })
            .subscribeNext {
                if $0.count > 0 {
                    self.tournaments.removeAll(keepCapacity: true)
                    self.tournaments.insertContentsOf($0, at: self.currentPage - 1)
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
        return tournaments.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: "TournamentTableViewCell", bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.Tournament.rawValue)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.Tournament.rawValue, forIndexPath: indexPath) as! TournamentTableViewCell
        cell.tournament = tournaments[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showTournament", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTournament"{
            if let vc = segue.destinationViewController as? TournamentViewController {
                if let tournamentIndex = tableView.indexPathForSelectedRow?.row {
                    vc.tournamentID = tournaments[tournamentIndex].id
                }
            }
        }
    }
    
}

