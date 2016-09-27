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
import PageMenu

class TeamViewController: UIViewController {
    
    var team: Team? {
        didSet {
            navigationItem.title = team?.name
            
            updateUI()
        }
    }
    
    fileprivate var pageMenu : CAPSPageMenu?
    
    fileprivate let membersController = UsersViewController()
    fileprivate let tournamentsController = TournamentsViewController()
    fileprivate let leaderboardController = RankingViewController()
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageMenu()
        
        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        self.provider?.getTeam(Int(team!.id))
            .debug()
            .catchError({ error in
                showError(error, from: self)
                return Observable.empty()
            })
            .subscribe(onNext: {
                self.team = $0
                
                if let members = self.team?.members {
                    
                    self.membersController.users = members
                    self.leaderboardController.users = members.sorted{ $0.score > $1.score }
                }
            })
            .addDisposableTo(self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        //load new information from the team
        if let team = self.team {
            
            navigationItem.title = team.name
        }
    }
    
    fileprivate func setupPageMenu() {
        var controllerArray : [UIViewController] = []
        
        membersController.title = "MEMBERS"
        controllerArray.append(membersController)
        
        
        tournamentsController.title = "TOURNAMENTS"
        controllerArray.append(tournamentsController)
        
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
            .menuItemFont(UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightMedium)),
        ]
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: frame, pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }
    
}
