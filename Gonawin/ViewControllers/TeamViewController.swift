//
//  TeamViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 12/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine
import RxSwift

class TeamViewController: UITableViewController {
    
    var teamID: Int64 = 0
    
    private var team: Team? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var teamImageView: UIWebView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var tournamentsLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private enum SegmentedControlState: Int {
        case Members = 0
        case Tournaments = 1
        case Leaderboard = 2
    }
    
    private let disposeBag = DisposeBag()
    private var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        self.provider?.getTeam(Int(teamID))
            .debug()
            .catchError({ error in
                showError(self, error: error)
                return Observable.empty()
            })
            .subscribeNext {
                self.team = $0
            }
            .addDisposableTo(self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        //load new information from the team
        if let team = self.team {
            let url = NSURL(string: team.imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            teamImageView.loadRequest(NSURLRequest(URL: url))
            
            nameLabel.text = team.name
            if let accuracy = team.accuracy {
                accuracyLabel.text = "\(round(accuracy * 100) / 100)"
            }
            membersLabel.text = "\(team.membersCount)"
            if let tournamentsCount = team.tournaments?.count {
                tournamentsLabel.text = "\(tournamentsCount)"
            }
            
            navigationItem.title = team.name
            
            tableView.reloadData()
        }
    }
    
    @IBAction func segmentedControlValueChanged() {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(segmentedControl.selectedSegmentIndex) {
        case SegmentedControlState.Tournaments.rawValue:
            return team?.tournaments?.count ?? 0
        default:
            return team?.members?.count ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch(segmentedControl.selectedSegmentIndex) {
        case SegmentedControlState.Members.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.User.rawValue, forIndexPath: indexPath) as! UserTableViewCell
            cell.user = team?.members?[indexPath.row]
            return cell
        case SegmentedControlState.Tournaments.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.Tournament.rawValue, forIndexPath: indexPath) as! TournamentTableViewCell
            cell.tournament = team?.tournaments?[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.Ranking.rawValue, forIndexPath: indexPath) as! UserRankingTableViewCell
            cell.user = team?.members?.sort{$0.score > $1.score}[indexPath.row]
            cell.rankinglabel.text = "\(indexPath.row + 1)"
            return cell
        }
    }
}
