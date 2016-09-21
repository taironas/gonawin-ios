//
//  ProfileViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import GonawinEngine

class ProfileViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIWebView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var tournamentsLabel: UILabel!
    @IBOutlet weak var teamsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = GonawinSession.session.currentUser {
            let url = URL(string: user.imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            profileImageView.loadRequest(URLRequest(url: url))
            let imageLayer = profileImageView.layer
            imageLayer.cornerRadius = profileImageView.frame.size.height/2
            imageLayer.masksToBounds = true
            nameLabel.text = user.username
            scoreLabel.text = "\(user.score)"
            tournamentsLabel.text = "\(user.tournamentIds.count)"
            teamsLabel.text = "\(user.teamIds.count)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case 0:
            print("TODO: not yet implemented!")
        case 1:
            presentLogoutAlert()
        default: break
        }
    }
    
    fileprivate func presentLogoutAlert() {
        let alert = UIAlertController(title: "Logout", message: "Are sure you want be logged out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in self.logout() }))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func logout()
    {
        GonawinSession.session.deleteSession()
    }
}
