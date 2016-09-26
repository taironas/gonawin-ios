//
//  TournamentsViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine
import RxSwift

class TournamentsViewController: UICollectionViewController {
                            
    var tournaments = [Tournament]()
    var currentPage = 1
    
    let cellIdentifier = "TournamentViewCell"
    let segueIdentifier = "showTournament"
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var provider: AuthorizedGonawinEngine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authorizationToken = GonawinSession.session.authorizationToken {
            provider = GonawinEngine.newAuthorizedGonawinEngine(authorizationToken)
        }
        
        currentPage = 1
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.provider?.getTournaments(currentPage, count: 20)
            .debug()
            .catchError({ error in
                showError(self as! Error, from: error as! UIViewController)
                return Observable.empty()
            })
            .subscribe(onNext: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if $0.count > 0 {
                    self.tournaments.removeAll(keepingCapacity: true)
                    self.tournaments.insert(contentsOf: $0, at: self.currentPage - 1)
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
        return tournaments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TournamentViewCell
        
        cell.tournament = tournaments[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let vc = segue.destination as? TournamentViewController {
                if let tournamentIndex = (collectionView?.indexPathsForSelectedItems?[0])?.row {
                    vc.tournament = tournaments[tournamentIndex]
                }
            }
        }
    }
}

extension TournamentsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds
        
        return CGSize(width: screenSize.width - 2*10.0, height: screenSize.width/3)
    }
}

