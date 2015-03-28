//
//  ProfileViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 11/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    private let gonawinAPI = GonawinAPI.client
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = gonawinAPI.currentUser {
            gonawinAPI.user(currentUser.id)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            println("TODO: not yet implemented!")
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
        if let accessToken = gonawinAPI.accessToken {
            KeychainService.deleteAccessToken(accessToken)
        }
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("Provider")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("CurrentUser")
        
        gonawinAPI.logout()
    }
}