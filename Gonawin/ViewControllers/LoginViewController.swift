//
//  LoginViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 14/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import Accounts

class LoginViewController: UIViewController {
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    override func viewDidLoad() {
    }
    
    @IBAction func Facebooklogin() {
        let facebookLogin = FacebookLogin()
        
        facebookLogin.login() {
            userInfo, error in
            
            if userInfo != nil {
                GonawinAPI.client.login(userInfo!.accessToken, provider: "facebook", id: userInfo!.id, email: userInfo!.email, name: userInfo!.name)
            }
            
            if error != nil {
                self.showError(error!)
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
