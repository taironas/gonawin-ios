//
//  GonawinController
//  Gonawin
//
//  Created by Remy JOURDE on 15/09/2014.
//  Copyright (c) 2014 Taironas. All rights reserved.
//

import UIKit

class GonawinController: UITabBarController, GonawinAPIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GonawinAPI.sharedInstance.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if user is already logged in
        if !GonawinAPI.sharedInstance.isLoggedIn() {
            self.performSegueWithIdentifier("showLogin", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didAuthenticatedWithAccessToken(accessToken: String, user: User)
    {
        // save access token in KeychainService
        KeychainService.saveAccessToken(accessToken)
        // store user in NSUserDefaults
        let data = NSKeyedArchiver.archivedDataWithRootObject(user.encoded())
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "CurrentUser")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didFailToAuthenticateWithError(error: NSError) {
        // inform user that something wrong happened
        println(error)
    }
    
    func didLogout() {
        self.performSegueWithIdentifier("showLogin", sender: self)
    }
}
