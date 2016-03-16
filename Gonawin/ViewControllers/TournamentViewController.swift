//
//  TournamentViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 15/03/2016.
//  Copyright © 2016 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine
import RxSwift

class TournamentViewController: UITableViewController {

    var tournamentID: Int64 = 0
    
    private var tournament: Tournament? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tournamentImageView: UIWebView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var teamsLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    private enum SegmentedControlState: Int {
        case Participants = 0
        case Teams = 1
        case Leaderboard = 2
    }
    
    private let disposeBag = DisposeBag()
    private var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        self.provider?.getTournament(Int(tournamentID))
            .debug()
            .catchError({ error in
                showError(self, error: error)
                return Observable.empty()
            })
            .subscribeNext {
                self.tournament = $0
            }
            .addDisposableTo(self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        //load new information from the team
        if let tournament = self.tournament {
            let url = NSURL(string: tournament.imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            tournamentImageView.loadRequest(NSURLRequest(URL: url))
            
            nameLabel.text = tournament.name
            if let start = tournament.start, let end =  tournament.end {
                datesLabel.text = start + " - " + end
            }
            participantsLabel.text = "\(tournament.participantsCount)"
            teamsLabel.text = "\(tournament.teamsCount)"
            
            navigationItem.title = tournament.name
            
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    @IBAction func segmentedControlValueChanged() {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(segmentedControl.selectedSegmentIndex) {
        case SegmentedControlState.Teams.rawValue:
            return tournament?.teams?.count ?? 0
        default:
            return tournament?.participants?.count ?? 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch(segmentedControl.selectedSegmentIndex) {
        case SegmentedControlState.Participants.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.User.rawValue, forIndexPath: indexPath) as! UserTableViewCell
            cell.user = tournament?.participants?[indexPath.row]
            return cell
        case SegmentedControlState.Teams.rawValue:
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.Team.rawValue, forIndexPath: indexPath) as! TeamTableViewCell
            cell.team = tournament?.teams?[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.Ranking.rawValue, forIndexPath: indexPath) as! UserRankingTableViewCell
            cell.user = tournament?.participants?.sort{$0.score > $1.score}[indexPath.row]
            cell.rankinglabel.text = "\(indexPath.row + 1)"
            return cell
        }
    }

}
