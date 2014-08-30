//
//  LoginViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 14/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GPPSignInDelegate {

    
    @IBOutlet weak var loginWithGooglePlusButton: GPPSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var signIn = GPPSignIn.sharedInstance()
        signIn.clientID = "664439623416-eahlk6rvfdpabp4e3g6uev5e83hklivd.apps.googleusercontent.com"
        signIn.scopes = [kGTLAuthScopePlusLogin]
        signIn.shouldFetchGoogleUserID = true;
        signIn.shouldFetchGoogleUserEmail = true;
        signIn.shouldFetchGooglePlusUser = true;
        signIn.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication,  error: NSError ) {
        println("accessToken = \(auth.accessToken)")
        
        var signIn = GPPSignIn.sharedInstance()
        let name = "\(signIn.googlePlusUser.name.givenName) \(signIn.googlePlusUser.name.familyName)"
        
        println("userID = \(signIn.userID)")
        println("userEmail = \(signIn.userEmail)")
        println("name = \(name)")
    }
      
}
