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
            let url = NSURL(string: user.imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)!
            profileImageView.loadRequest(NSURLRequest(URL: url))
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            print("TODO: not yet implemented!")
        case 1:
            presentLogoutAlert()
        default: break
        }
    }
    
    private func presentLogoutAlert() {
        let alert = UIAlertController(title: "Logout", message: "Are sure you want be logged out?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in self.logout() }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func logout()
    {
        GonawinSession.session.deleteSession()
    }
}
