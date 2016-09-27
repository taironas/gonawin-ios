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
    
    var team: Team? {
        didSet {
            navigationItem.title = team?.name
        }
    }
    
    fileprivate var members: [User]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var provider: AuthorizedGonawinEngine?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIWebView!
    @IBOutlet weak var membersCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        if let team = self.team {
            nameLabel.text = team.name
            let url = URL(string: (team.imageURL + "&size=80").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            avatarImageView.loadRequest(URLRequest(url: url))
            membersCountLabel.text = "\(team.membersCount)"
            
            fetchMembers(of: Int(team.id))
        }
    }
    
    fileprivate func fetchMembers(of teamID: Int) {
        self.provider?.getTeam(Int(team!.id))
            .debug()
            .catchError({ error in
                showError(error, from: self)
                return Observable.empty()
            })
            .subscribe(onNext: {
                if let members = $0.members {
                    
                    self.members = members.sorted{ $0.score > $1.score }
                }
            })
            .addDisposableTo(self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCell(for: indexPath)
    }
    
    fileprivate func configureCell(for indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: TableViewCellIdentifier.ranked.rawValue, bundle: nil ), forCellReuseIdentifier: TableViewCellIdentifier.ranked.rawValue)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.ranked.rawValue, for: indexPath) as! RankedUserViewCell
        cell.user = members?[indexPath.row]
        cell.rankinglabel.text = "\(indexPath.row + 1)"
        
        return cell
    }
    
}
