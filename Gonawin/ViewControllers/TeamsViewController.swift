//
//  TeamsViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine
import RxSwift

class TeamsViewController: UICollectionViewController {
    var teams = [Team]()
    var currentPage = 1
    
    private let disposeBag = DisposeBag()
    private var provider: AuthorizedGonawinEngine?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        currentPage = 1
        
        self.provider?.getTeams(currentPage, count: 20)
            .debug()
            .catchError({ error in
                showError(self, error: error)
                return Observable.empty()
            })
            .subscribeNext {
                if $0.count > 0 {
                    self.teams.removeAll(keepCapacity: true)
                    self.teams.insertContentsOf($0, at: self.currentPage - 1)
                    self.collectionView?.reloadData()
                }
            }
            .addDisposableTo(self.disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionViewCellIdentifier.Team.rawValue, forIndexPath: indexPath) as! TeamCollectionViewCell
        
        cell.team = teams[indexPath.row]
        
        cell.layer.cornerRadius = 5.0;
        //        cell.layer.shadowColor = UIColor.grayColor().CGColor;
        //        cell.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        //        cell.layer.shadowRadius = 2.0;
        //        cell.layer.shadowOpacity = 1.0;
        //        cell.layer.masksToBounds = false;
        //        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).CGPath;
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showTeam", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTeam"{
            if let vc = segue.destinationViewController as? TeamViewController {
                if let teamIndex = collectionView?.indexPathsForSelectedItems()?[0].row {
                    vc.teamID = teams[teamIndex].id
                }
            }
        }
    }
    
    override func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        // scroll to bottom
        let currentOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - currentOffset
        let height = scrollView.frame.size.height
        if distanceFromBottom < height {
            currentPage = currentPage + 1
            
            self.provider?.getTeams(currentPage, count: 20)
                .debug()
                .catchError({ error in
                    showError(self, error: error)
                    return Observable.empty()
                })
                .subscribeNext {
                    if $0.count > 0 {
                        self.teams.appendContentsOf($0)
                        self.collectionView?.reloadData()
                    }
                }
                .addDisposableTo(self.disposeBag)
        }
    }
}
