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
    
    fileprivate var tournament: Tournament? {
        didSet {
            updateUI()
            
            fetchCalendar()
        }
    }
    
    fileprivate var pageMenu : CAPSPageMenu?
    
    fileprivate let matchesController = MatchesViewController()
    fileprivate let leaderboardController = RankingViewController()
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageMenu()
        
        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        self.provider?.getTournament(Int(tournamentID))
            .debug()
            .catchError({ error in
                showError(error, from: self)
                return Observable.empty()
            })
            .subscribe(onNext: {
                self.tournament = $0
            })
            .addDisposableTo(self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func updateUI() {
        //load new information from the team
        if let tournament = self.tournament {
            
            navigationItem.title = tournament.name
        }
    }
    
    fileprivate func fetchCalendar() {
        self.provider?.getTournamentCalendar(Int(tournamentID))
            .debug()
            .catchError({ error in
                showError(error, from: self)
                return Observable.empty()
            })
            .subscribe(onNext: {
                self.matchesController.calendar = $0
            })
            .addDisposableTo(self.disposeBag)
    }
    
    fileprivate func setupPageMenu() {
        var controllerArray = [UIViewController]()
        
        matchesController.title = "MATCHES"
        controllerArray.append(matchesController)
        
        leaderboardController.title = "LEADERBOARD"
        controllerArray.append(leaderboardController)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(0.0),
            .menuHeight(44.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.1),
            .selectionIndicatorColor(UIColor.greenSeaFoam),
            .selectedMenuItemLabelColor(UIColor.greenSeaFoam),
            .unselectedMenuItemLabelColor(UIColor.black),
            .scrollMenuBackgroundColor(UIColor.clear),
            .bottomMenuHairlineColor(UIColor.groupTableViewBackground),
            .menuItemFont(UIFont.systemFont(ofSize: 13.0, weight: UIFontWeightMedium)),
            ]
        
        let frame = CGRect(x:0, y:0, width: view.frame.width, height: view.frame.height)
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: frame, pageMenuOptions: parameters)
        
        view.addSubview(pageMenu!.view)
    }
}
