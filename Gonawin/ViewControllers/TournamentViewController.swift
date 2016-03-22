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
        tableView.registerNib(UINib(nibName: "MatchTableViewCell", bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.Match.rawValue)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier.Match.rawValue, forIndexPath: indexPath) as! MatchTableViewCell
        cell.match = calendar?.days[indexPath.section].matches[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 109.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 5, width: tableView.frame.width, height: 20))
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        let headerView = UIView()
        headerView.addSubview(titleLabel)
        headerView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        return headerView;
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
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
