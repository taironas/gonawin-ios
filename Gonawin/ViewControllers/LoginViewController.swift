//
//  LoginViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 14/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import OAuth2

class LoginViewController: UITableViewController {
    
    lazy var facebook = FacebookAuthentication.sharedInstance
    lazy var googlePlus = GooglePlusAuthentication.sharedInstance
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            authenticateWithGoogle()
        case 1:
            authenticateWithTwitter()
        case 2:
            authenticateWithFacebook()
        default: break
        }
    }

    private func authenticateWithGoogle() {
        googlePlus.authorize(self) { didFail, error in
            if didFail && error != nil { self.showError(error!) }
        }
        
    }
    
    private func authenticateWithTwitter() {
        showErrorDescription("Not yet implemented!")
    }
    
    private func authenticateWithFacebook() {
        facebook.authorize(self) { didFail, error in
            if didFail && error != nil {
                self.showError(error!)
            }
            else {
                self.facebook.userInfo { result in
                    switch result {
                    case let .Error(error):
                        self.showError(error)
                    case let .Value(boxedUser):
                        let userInfo = boxedUser.value
                        GonawinAPI.sharedInstance.login(self.facebook.accessToken, provider: "facebook", id: userInfo.id.toInt()!, email: userInfo.email, name: userInfo.name)
                    }
                }
            }
        }
    }
    
    private func showError(error: NSError) {
        showErrorDescription(error.localizedDescription)
    }
    
    private func showErrorDescription(description: String) {
        let alert = UIAlertController(title: "Error", message: description, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
