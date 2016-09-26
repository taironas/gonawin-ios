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

    var tournament: Tournament? {
        didSet {
            navigationItem.title = tournament?.name
        }
    }
    
    fileprivate var calendar: TournamentCalendar? {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIWebView!
    @IBOutlet weak var participantsCountLabel: UILabel!
    @IBOutlet weak var teamsCountLabel: UILabel!
    
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        if let tournament = self.tournament {
            nameLabel.text = tournament.name
            let url = URL(string: (tournament.imageURL + "&size=80").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            logoImageView.loadRequest(URLRequest(url: url))
            participantsCountLabel.text = "\(tournament.participantsCount)"
            teamsCountLabel.text = "\(tournament.teamsCount)"
            
            fetchCalendar()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func fetchCalendar() {
        if let tournamentID = tournament?.id {
            self.provider?.getTournamentCalendar(Int(tournamentID))
                .debug()
                .catchError({ error in
                    showError(error, from: self)
                    return Observable.empty()
                })
                .subscribe(onNext: {
                    self.calendar = $0
                })
                .addDisposableTo(self.disposeBag)
        }
    }
    
    fileprivate let dateFormatter = DateFormatter()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return calendar?.days.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendar?.days[section].matches.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return format(calendar?.days[section].day)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(for: indexPath)
    }
    
    fileprivate func configureCell(for indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: TableViewCellIdentifier.match.rawValue, bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.match.rawValue)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.match.rawValue, for: indexPath) as! MatchTableViewCell
        cell.match = calendar?.days[indexPath.section].matches[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 109.0
    }
    
    fileprivate func format(_ day: String?) -> String {
        guard let day = day else {
            return ""
        }
        
        dateFormatter.dateFormat = "yyyy-MM-ddEEEEEHH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let date = dateFormatter.date(from: day)
        
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date!)
    }
}
