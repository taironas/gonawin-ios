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
            .MenuHeight(44.0),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1),
            .SelectionIndicatorColor(UIColor.greenSeaFoamColor()),
            .SelectedMenuItemLabelColor(UIColor.greenSeaFoamColor()),
            .UnselectedMenuItemLabelColor(UIColor.blackColor()),
            .ScrollMenuBackgroundColor(UIColor.clearColor()),
            .BottomMenuHairlineColor(UIColor.groupTableViewBackgroundColor()),
            .MenuItemFont(UIFont.systemFontOfSize(13.0, weight: UIFontWeightMedium)),
            ]
        
        let frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: frame, pageMenuOptions: parameters)
        
        view.addSubview(pageMenu!.view)
    }
}
