//
//  LoginViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 14/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, GPPSignInDelegate, GonawinClientDelegate {

    
    @IBOutlet weak var googlePlusButton: GPPSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var signIn = GPPSignIn.sharedInstance()
        signIn.clientID = "664439623416-eahlk6rvfdpabp4e3g6uev5e83hklivd.apps.googleusercontent.com"
        signIn.scopes = [kGTLAuthScopePlusLogin]
        signIn.shouldFetchGoogleUserID = true
        signIn.shouldFetchGoogleUserEmail = true
        signIn.shouldFetchGooglePlusUser = true
        signIn.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func finishedWithAuth(auth: GTMOAuth2Authentication,  error: NSError) {
        var signIn = GPPSignIn.sharedInstance()
        
        let name = "\(signIn.googlePlusUser.name.givenName) \(signIn.googlePlusUser.name.familyName)"
        
        GonawinClient.sharedInstance.loginWithGooglePlus(auth.accessToken, id: signIn.userID, email: signIn.userEmail, name: name)
        GonawinClient.sharedInstance.delegate = self;
    }
    
    func didAuthenticatedWithAccessToken(accessToken: String, user: User)
    {
        // store access token in NSUserDefaults
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "AccessToken")
        // store provider in NSUserDefaults
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "Provider")
        // store user in NSUserDefaults
        let data = NSKeyedArchiver.archivedDataWithRootObject(user.encoded())
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "CurrentUser")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didFailToAuthenticateWithError(error: NSError) {
        // inform user that something wrong happened
        println(error)
    }
    
}
