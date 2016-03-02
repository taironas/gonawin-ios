//
//  LoginViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 14/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import Accounts
import GonawinEngine

class LoginViewController: UIViewController {
    
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var twitterLoginButton: UIButton!
    
    @IBAction func Facebooklogin() {
        let facebookLogin = FacebookLogin()
        
        facebookLogin.login() {
            userInfo, error in
            if userInfo != nil {
                
                //GonawinAPI.client.login(userInfo!.accessToken, provider: "facebook", id: userInfo!.id, email: userInfo!.email, name: userInfo!.name)
            }
            
            if error != nil {
                showError(self, error: error!)
            }
        }

    }
    
    @IBAction func Twiterlogin() {
        let twitterLogin = TwitterLogin()

        twitterLogin.login {
            userInfo, error in
            if userInfo != nil {
                //GonawinAPI.client.login(userInfo!.accessToken, provider: "twitter", id: userInfo!.id, email: userInfo!.email, name: userInfo!.name)
            }
            
            if error != nil {
                showError(self, error: error!)
            }
        }
        
    }
}
