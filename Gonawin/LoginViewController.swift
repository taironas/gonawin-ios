//
//  LoginViewController.swift
//  Gonawin
//
//  Created by Remy JOURDE on 14/08/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, GPPSignInDelegate {

    
    @IBOutlet weak var googlePlusButton: GPPSignInButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
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
        var signIn = GPPSignIn.sharedInstance()
        
        let name = "\(signIn.googlePlusUser.name.givenName) \(signIn.googlePlusUser.name.familyName)"
        
        let authParams = ["access_token": auth.accessToken, "provider": "google", "id": signIn.userID, "email": signIn.userEmail, "name": name]
        Alamofire.request(.GET, "http://www.gonawin.com/j/auth/", parameters: authParams)
            .response { (request, response, data, error) in
                let result: Result<User>  = parseData(data as NSData, response, error)
                
                switch result {
                case let .Error(error):
                    println(error)
                case let .Value(boxedUser):
                    let user = boxedUser.value
                    self.usernameLabel?.text = user.username
                }
        }
    }
    
}
