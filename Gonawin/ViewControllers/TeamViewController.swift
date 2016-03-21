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
    
    private var pageMenu : CAPSPageMenu?
    
    private let membersController = UsersViewController()
    private let tournamentsController = TournamentsViewController()
    private let leaderboardController = RankingViewController()
    
    private let disposeBag = DisposeBag()
    private var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageMenu()
        
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
                
                if let members = self.team?.members {
                    
                    self.membersController.users = members
                    self.leaderboardController.users = members.sort{ $0.score > $1.score }
                }
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
    
    private func setupPageMenu() {
        var controllerArray : [UIViewController] = []
        
        membersController.title = "MEMBERS"
        controllerArray.append(membersController)
        
        
        tournamentsController.title = "TOURNAMENTS"
        controllerArray.append(tournamentsController)
        
        leaderboardController.title = "LEADERBOARD"
        controllerArray.append(leaderboardController)
        
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(0.0),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemSeparatorPercentageHeight(0.1),
            .SelectionIndicatorColor(UIColor(red: 255.0/255.0, green: 160.0/255.0, blue: 122.0/255.0, alpha: 1.0)),
            .SelectedMenuItemLabelColor(UIColor(red: 255.0/255.0, green: 160.0/255.0, blue: 122.0/255.0, alpha: 1.0)),
            .UnselectedMenuItemLabelColor(UIColor.blackColor()),
            .ScrollMenuBackgroundColor(UIColor.clearColor()),
            .BottomMenuHairlineColor(UIColor.groupTableViewBackgroundColor()),
            .MenuItemFont(UIFont.systemFontOfSize(13.0, weight: UIFontWeightMedium)),
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 220.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        self.view.addSubview(pageMenu!.view)
    }
    
}
