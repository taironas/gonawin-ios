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
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        currentPage = 1
        
        self.provider?.getTournaments(currentPage, count: 20)
            .debug()
            .catchError({ error in
                showError(self as! Error, from: error as! UIViewController)
                return Observable.empty()
            })
            .subscribe(onNext: {
                if $0.count > 0 {
                    self.tournaments.removeAll(keepingCapacity: true)
                    self.tournaments.insert(contentsOf: $0, at: self.currentPage - 1)
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
        return tournaments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "TournamentTableViewCell", bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.Tournament.rawValue)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.Tournament.rawValue, for: indexPath) as! TournamentTableViewCell
        cell.tournament = tournaments[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTournament", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTournament"{
            if let vc = segue.destination as? TournamentViewController {
                if let tournamentIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
                    vc.tournamentID = tournaments[tournamentIndex].id
                }
            }
        }
    }
    
}

