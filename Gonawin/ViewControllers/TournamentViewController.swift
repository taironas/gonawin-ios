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
import PageMenu

class TournamentViewController: UIViewController {

    var tournamentID: Int64 = 0
    
    private var tournament: Tournament? {
        didSet {
            updateUI()
            
            fetchCalendar()
        }
    }
    
    @IBOutlet weak var tournamentImageView: UIWebView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var teamsLabel: UILabel!
    
    private var pageMenu : CAPSPageMenu?
    
    private let matchesController = MatchesViewController()
    private let leaderboardController = RankingViewController()
    
    private let disposeBag = DisposeBag()
    private var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageMenu()
        
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
                self.matchesController.calendar = $0
            }
            .addDisposableTo(self.disposeBag)
    }
    
    private func setupPageMenu() {
        var controllerArray : [UIViewController] = []
        
        matchesController.title = "MATCHES"
        controllerArray.append(matchesController)
        
        leaderboardController.title = "LEADERBOARD"
        controllerArray.append(leaderboardController)
        
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(0.0),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1),
            .SelectionIndicatorColor(UIColor.orangeColor()),
            .SelectedMenuItemLabelColor(UIColor.orangeColor()),
            .UnselectedMenuItemLabelColor(UIColor.blackColor()),
            .ScrollMenuBackgroundColor(UIColor.clearColor()),
            .BottomMenuHairlineColor(UIColor.groupTableViewBackgroundColor()),
            .MenuItemFont(UIFont.systemFontOfSize(13.0, weight: UIFontWeightMedium)),
            ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 180.0, self.view.frame.width, self.view.frame.height - 180.0), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }
}
