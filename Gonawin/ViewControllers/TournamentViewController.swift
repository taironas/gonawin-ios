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
            
            fetchCalendar()
        }
    }
    
    private var calendar: TournamentCalendar? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var tournamentImageView: UIWebView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var teamsLabel: UILabel!
    
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
    
    private func updateUI() {
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
        }
    }
    
    private func fetchCalendar() {
        self.provider?.getTournamentCalendar(Int(tournamentID))
            .debug()
            .catchError({ error in
                showError(self, error: error)
                return Observable.empty()
            })
            .subscribeNext {
                self.calendar = $0
            }
            .addDisposableTo(self.disposeBag)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return calendar?.days.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendar?.days[section].matches.count ?? 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formatDayDate(calendar?.days[section].day)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return configureCell(forIndexPath: indexPath)
    }
    
    private func configureCell(forIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.Match.rawValue, forIndexPath: indexPath) as! MatchTableViewCell
        cell.match = calendar?.days[indexPath.section].matches[indexPath.row]
        
        return cell
    }
    
    private func formatDayDate(day: String?) -> String {
        guard let day = day else {
            return ""
        }
        
        dateFormatter.dateFormat = "yyyy-MM-ddEEEEEHH:mm:ssZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        
        let date = dateFormatter.dateFromString(day)
        
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = .NoStyle
        
        return dateFormatter.stringFromDate(date!)
    }
}
