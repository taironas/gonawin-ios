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
    
    let segueIdentifier = "showTeam"
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var provider: AuthorizedGonawinEngine?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        currentPage = 1
        
        self.provider?.getTeams(currentPage, count: 20)
            .debug()
            .catchError({ error in
                showError(self as! Error, from: error as! UIViewController)
                return Observable.empty()
            })
            .subscribe(onNext: {
                if $0.count > 0 {
                    self.teams.removeAll(keepingCapacity: true)
                    self.teams.insert(contentsOf: $0, at: self.currentPage - 1)
                    self.collectionView?.reloadData()
                }
            })
            .addDisposableTo(self.disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellIdentifier.team.rawValue, for: indexPath) as! TeamViewCell
        
        cell.team = teams[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let vc = segue.destination as? TeamViewController {
                if let teamIndex = (collectionView?.indexPathsForSelectedItems?[0])?.row {
                    vc.team = teams[teamIndex]
                }
            }
        }
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        // scroll to bottom
        let currentOffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - currentOffset
        let height = scrollView.frame.size.height
        if distanceFromBottom < height {
            currentPage = currentPage + 1
            
            self.provider?.getTeams(currentPage, count: 20)
                .debug()
                .catchError({ error in
                    showError(self as! Error, from: error as! UIViewController)
                    return Observable.empty()
                })
                .subscribe(onNext: {
                    if $0.count > 0 {
                        self.teams.append(contentsOf: $0)
                        self.collectionView?.reloadData()
                    }
                })
                .addDisposableTo(self.disposeBag)
        }
    }
}
