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
        }
    }
    
    @IBAction func segmentedControlValueChanged() {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(segmentedControl.selectedSegmentIndex) {
        case 0:
            return 0
        case 1:
            return team?.members?.count ?? 0
        case 2:
            return team?.tournaments?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch(segmentedControl.selectedSegmentIndex) {
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("TeamTournamentCell", forIndexPath: indexPath) as! TeamTournamentTableViewCell
            cell.tournament = team?.tournaments?[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("TeamMemberCell", forIndexPath: indexPath) as! TeamMemberTableViewCell
            cell.member = team?.members?[indexPath.row]
            return cell
        }
    }
}
